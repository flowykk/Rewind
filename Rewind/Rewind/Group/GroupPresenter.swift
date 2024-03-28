//
//  GroupPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation
import UIKit

final class GroupPresenter: AllMembersTablePresenterProtocol {
    private weak var view: GroupViewController?
    weak var membersTable: MembersTableView?
    weak var groupMediaCollection: GroupMediaCollectionView?
    private var router: GroupRouter
    
    init(view: GroupViewController?, router: GroupRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToRewind()
    }
    
    func groupSettingsButtonTapped() {
        router.navigateToGroupSettings()
    }
    
    func groupMediaButtonTapped() {
        router.navigateToGallery()
    }
    
    func rowSelected(_ row: MembersTableView.CellType) {
        switch row {
        case .addButton:
            LoadingView.show(in: view)
            router.presentShareLinkViewController()
        case .allMembersButton:
            router.navigateToAllMembers()
        default:
            print("member selected")
        }
    }
    
    func deleteMemberButtonTapped(memberId: Int) {
        router.presentDeleteMemberConfirmationAlert(memberId: memberId)
    }
    
    func removeMemberFromGroup(memberId: Int) {
        LoadingView.show(in: view, backgroundColor: view?.view.backgroundColor ?? .systemBackground)
        if let groupId = DataManager.shared.getCurrectGroupId() {
            requestRemoveMemberFromGroup(groupId: groupId, memberId: memberId)
        } else {
            LoadingView.hide(from: view)
        }
    }
    
    func getGroupBasicData() {
        LoadingView.show(in: view, backgroundColor: .systemBackground)
        view?.disableSettingsButton()
        guard let groupId = DataManager.shared.getCurrentGroup()?.id else {
            router.navigateToRewind()
            LoadingView.hide(from: view)
            return
        }
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        requestGroupBasicData(groupId: groupId, userId: userId, membersQuantity: 4, mediaQuantity: 4)
    }
}

// MARK: - Network Request Funcs
extension GroupPresenter {
    private func requestGroupBasicData(groupId: Int, userId: Int, membersQuantity: Int, mediaQuantity: Int) {
        NetworkService.getGroupBasicData(groupId: groupId, userId: userId, membersQuantity: membersQuantity, mediaQuantity: mediaQuantity) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetGroupBasicDataResponse(response)
            }
        }
    }
    
    private func requestRemoveMemberFromGroup(groupId: Int, memberId: Int) {
        NetworkService.removeMemberFromGroup(groupId: groupId, memberId: memberId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleDeleteMemberFromGroupResponse(response, memberId: memberId)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension GroupPresenter {
    private func handleGetGroupBasicDataResponse(_ response: NetworkResponse) {
        if response.success, let json = response.json {
            if let groupId = json["id"] as? Int,
               let groupName = json["name"] as? String,
               let ownerJson = json["owner"] as? [String : Any],
               let membersJsonArray = json["firstMembers"] as? [[String : Any]],
               let mediaJsonArray = json["firstMedia"] as? [[String : Any]]
            {
                var groupImage: UIImage? = nil
                if let base64String = json["image"] as? String {
                    groupImage = UIImage(base64String: base64String)
                }
                
                let userId = UserDefaults.standard.integer(forKey: "UserId")
                let userName = UserDefaults.standard.string(forKey: "UserName") ?? "Anonymous"
                let userImage = UserDefaults.standard.image(forKey: "UserImage")
                
                let user = GroupMember(id: userId, name: userName, role: .user, miniImage: userImage)
                guard let owner = GroupMember(json: ownerJson, role: .owner) else { return }
                
                var members: [GroupMember] = [owner]
                if user.id != owner.id {
                    members.insert(user, at: 0)
                }
                
                for memberJson in membersJsonArray {
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
                
                var medias: [Media] = []
                
                for mediaJson in mediaJsonArray {
                    if let media = Media(json: mediaJson) {
                        medias.append(media)
                    }
                }
                
                let miniImage: UIImage? = DataManager.shared.getCurrentGroup()?.miniImage
                
                let currentGroup = Group(id: groupId, name: groupName, ownerId: owner.id, bigImage: groupImage, miniImage: miniImage, owner: owner, members: members, medias: medias)
                DataManager.shared.setCurrentGroup(currentGroup)
                
                DispatchQueue.main.async { [weak self] in
                    self?.view?.configureUIForCurrentGroup()
                    self?.membersTable?.configureData(members: members)
                    self?.groupMediaCollection?.configureData(medias: medias)
                    self?.view?.updateViewsHeight()
                    LoadingView.hide(from: self?.view)
                    self?.view?.enableSettingsButton()
                }
            } else {
                
            }
        } else {
            print("something went wrong")
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
