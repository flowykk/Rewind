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
        
//        membersTable?.members.removeAll { $0.id == userId }
//        membersTable?.reloadData()
//        view?.updateViewsHeight()
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
    
    private func requestDeleteMember(memberId: Int) {
        
    }
}

// MARK: - Network Response Handlers
extension AllMembersPresenter {
    private func handleGetGroupMembersResponse(_ response: NetworkResponse) {
        if response.success, let jsonArray = response.jsonArray {
            let user = GroupMember(id: UserDefaults.standard.integer(forKey: "UserId"), name: UserDefaults.standard.string(forKey: "UserName") ?? "Anonymous", role: .user)
            guard let owner = DataManager.shared.getCurrentGroup()?.owner else { return }
            
            var members: [GroupMember] = []
            
            for memberJson in jsonArray {
                if var member = GroupMember(json: memberJson, role: .member) {
                    if member.id == user.id {
                        member.role = .user
                    }
                    if member.id == owner.id {
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
}
