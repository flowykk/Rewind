//
//  AllGroupsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation
import UIKit

final class AllGroupsPresenter {
    private weak var view: AllGroupsViewController?
    weak var tableView: GroupsTableView?
    private var router: AllGroupsRouter
    
    init(view: AllGroupsViewController?, router: AllGroupsRouter) {
        self.view = view
        self.router = router
    }
    
    func getUserGroups() {
        LoadingView.show(in: view)
        requestUserGroups()
    }
    
    func backButtonTapped() {
        router.navigateToAccount()
    }
    
    func addGroupButtonSelected() {
        router.presentEnterGroupName()
    }
    
    func addGroup(_ group: Group) {
        tableView?.groups.append(group)
        tableView?.reloadData()
        view?.updateViewsHeight()
    }
    
    func groupSelected(_ group: Group) {
        DataManager.shared.setCurrentGroup(group)
        router.navigateToRewind()
    }
}

// MARK: - Network Request Funcs
extension AllGroupsPresenter {
    private func requestUserGroups() {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.getUserGroups(userId: userId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetUserGroupsResponse(response)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension AllGroupsPresenter {
    private func handleGetUserGroupsResponse(_ response: NetworkResponse) {
        if response.success, let jsonArray = response.jsonArray {
            var groups: [Group] = []
            
            let currentGroupId = DataManager.shared.getCurrectGroupId()
            var isCurrentGroupInGroups: Bool = false
            
            for el in jsonArray {
                if let id = el["id"] as? Int, let ownerId = el["ownerId"] as? Int, let name = el["name"] as? String {
                    if id == currentGroupId {
                        isCurrentGroupInGroups = true
                    }
                    var miniImage: UIImage? = nil
                    if let imageString = el["tinyImage"] as? String {
                        miniImage = UIImage(base64String: imageString)
                    }
                    groups.append(Group(id: id, name: name, ownerId: ownerId, miniImage: miniImage))
                }
            }
            
            if isCurrentGroupInGroups == false {
                if let currGID = currentGroupId {
                    DataManager.shared.removeGroupFromGroups(groupId: currGID)
                    DataManager.shared.setCurrentGroupToRandomUserGroup()
                }
            }
            
            DataManager.shared.setUserGroups(groups)
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.groups = groups
                self?.tableView?.reloadData()
                LoadingView.hide(from: self?.view)
            }
        } else {
            print(response.statusCode as Any)
            print(response.message as Any)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
}
