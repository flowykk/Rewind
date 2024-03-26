//
//  AllMembersPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import Foundation

final class AllMembersPresenter: AllMembersTablePresenterProtocol {
    private weak var view: AllMembersViewController?
    weak var membersTable: MembersTableView?
    private var router: AllMembersRouter
    
    init(view: AllMembersViewController?, router: AllMembersRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToGroup()
    }
    
    func rowSelected(_ row: MembersTableView.CellType) {
        //        if row == .addButton
    }
    
    func deleteMemberButtonTapped(memberId: Int) {
        router.presentDeleteMemberConfirmationAlert(memberId: memberId)
    }
    
    func deleteMember(withId memberId: Int) {
        LoadingView.show(in: view, backgroundColor: view?.view.backgroundColor ?? .systemBackground)
        if let groupId = DataManager.shared.getCurrectGroupId() {
            requestDeleteMember(groupId: groupId, memberId: memberId)
        } else {
            LoadingView.hide(from: view)
        }
    }
    
    func getGroupMembers() {
        LoadingView.show(in: view, backgroundColor: view?.view.backgroundColor ?? .systemBackground)
        guard let groupId = DataManager.shared.getCurrectGroupId() else {
            LoadingView.hide(from: view)
            return
        }
        requestGroupMembers(groupId: groupId)
    }
}

// MARK: - Network Request Funcs
extension AllMembersPresenter {
    private func requestGroupMembers(groupId: Int) {
        NetworkService.getGroupMembers(groupId: groupId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetGroupMembersResponse(response)
            }
        }
    }
    
    private func requestDeleteMember(groupId: Int, memberId: Int) {
        NetworkService.removeMemberFromGroup(groupId: groupId, memberId: memberId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleDeleteMemberFromGroupResponse(response, memberId: memberId)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension AllMembersPresenter {
    private func handleGetGroupMembersResponse(_ response: NetworkResponse) {
        if response.success, let jsonArray = response.jsonArray {
            let userId = UserDefaults.standard.integer(forKey: "UserId")
            guard let ownerId = DataManager.shared.getCurrentGroup()?.owner?.id else { return }
            
            var members: [GroupMember] = []
            
            for memberJson in jsonArray {
                if var member = GroupMember(json: memberJson, role: .member) {
                    if member.id == userId {
                        member.role = .user
                    }
                    if member.id == ownerId {
                        member.role = .owner
                    }
                    members.append(member)
                }
            }
            
            let sortedMembers = members.sorted { (member1, member2) -> Bool in
                let roleOrder: [MemberRole] = [.user, .owner, .member]
                
                guard let index1 = roleOrder.firstIndex(of: member1.role), let index2 = roleOrder.firstIndex(of: member2.role) else {
                    return false
                }
                
                return index1 < index2
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.membersTable?.configureData(members: sortedMembers)
                self?.view?.updateViewsHeight()
                LoadingView.hide(from: self?.view)
            }
        } else {
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
    
    private func handleDeleteMemberFromGroupResponse(_ response: NetworkResponse, memberId: Int) {
        if response.success {
            membersTable?.members.removeAll { $0.id == memberId }
            DispatchQueue.main.async { [weak self] in
                self?.membersTable?.reloadData()
                self?.view?.updateViewsHeight()
                LoadingView.hide(from: self?.view)
            }
        } else {
            print("something went wrong")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
}
