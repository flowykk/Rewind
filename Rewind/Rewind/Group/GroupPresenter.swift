//
//  GroupPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation
import UIKit

final class GroupPresenter {
    private weak var view: GroupViewController?
    weak var membersTable: MembersTableView?
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
    
    func getGroupBasicData() {
        LoadingView.show(in: view, backgroundColor: .systemBackground)
        view?.disableSettingsButton()
        guard let groupId = DataManager.shared.getCurrentGroup()?.id else {
            print("group not selected")
            LoadingView.hide(from: view)
            return
        }
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        fetchGroupBasicData(groupId: groupId, userId: userId, membersQuantity: 4, mediaQuantity: 4)
    }
}

// MARK: - Network Request Funcs
extension GroupPresenter {
    private func fetchGroupBasicData(groupId: Int, userId: Int, membersQuantity: Int, mediaQuantity: Int) {
        NetworkService.getGroupBasicData(groupId: groupId, userId: userId, membersQuantity: membersQuantity, mediaQuantity: mediaQuantity) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetGroupBasicDataResponse(response)
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
               let ownerJson = json["owner"] as? [String: Any],
               let membersJsonArray = json["firstMembers"] as? [[String: Any]]
            {
                var groupImage: UIImage? = nil
                
                if let base64String = json["image"] as? String {
                    groupImage = UIImage(base64String: base64String)
                }
                
                let user = GroupMember(id: UserDefaults.standard.integer(forKey: "UserId"), name: UserDefaults.standard.string(forKey: "UserName") ?? "Anonymous", role: .user)
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
                
                let currentGroup = Group(id: groupId, name: groupName, ownerId: owner.id, bigImage: groupImage, owner: owner, members: members)
                DataManager.shared.setCurrentGroup(currentGroup)
                
                DispatchQueue.main.async { [weak self] in
                    self?.view?.configureData()
                    self?.membersTable?.configureData(members: members)
                    self?.view?.updateViewsHeight()
                    self?.view?.enableSettingsButton()
                    LoadingView.hide(from: self?.view)
                }
            } else {
                
            }
        } else {
            print("something went wrong")
            print("--------------------")
            print(response.statusCode as Any)
            print(response.message as Any)
            print(response)
            print("--------------------")
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
}
