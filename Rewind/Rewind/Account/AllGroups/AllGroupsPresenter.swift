//
//  AllGroupsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation

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
        fetchUserGroups()
    }
    
    func backButtonTapped() {
        router.navigateToAccount()
    }
    
    func addGroupButtonSelected() {
        router.navigateToAddGroup()
    }
    
    func addGroup(groupName: String) {
        tableView?.groups.append(Group(id: -1, name: groupName))
        tableView?.reloadData()
        view?.updateViewsHeight()
    }
}

// MARK: - Network Request Funcs
extension AllGroupsPresenter {
    private func fetchUserGroups() {
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
        if response.success, let message = response.message {
            guard let jsonData = message.data(using: .utf8) else { return }
            guard let groupsArray = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else { return }
            
            var groups: [Group] = []
            
            for el in groupsArray {
                if let id = el["id"] as? Int, let name = el["name"] as? String {
                    groups.append(Group(id: id, name: name))
                }
            }
            
            tableView?.groups = groups
            
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(from: self?.view)
                self?.tableView?.reloadData()
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
    
