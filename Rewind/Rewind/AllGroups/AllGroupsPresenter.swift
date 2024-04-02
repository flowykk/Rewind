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
    weak var groupsTable: GroupsTableView?
    private var router: AllGroupsRouter
    
    private var originalGroups: [Group] = []
    
    init(view: AllGroupsViewController?, router: AllGroupsRouter) {
        self.view = view
        self.router = router
    }
    
    func searchTextChanged(newValue: String?) {
        guard let newValue = newValue else { return }
        
        var filteredGroups: [Group] = []
        
        if newValue.isEmpty {
            filteredGroups = originalGroups
        } else {
            filteredGroups = originalGroups.filter({ $0.name.lowercased().contains(newValue.lowercased()) })
        }
        
        groupsTable?.groups = filteredGroups
        groupsTable?.reloadData()
        view?.updateViewsHeight()
        groupsTable?.groups = originalGroups
    }
    
    func goToCurrentGroupAfterAdding() {
        router.goToCurrentGroupAfterAdding()
    }
    
    func getUserGroups() {
        LoadingView.show(inVC: view, backgroundColor: .systemBackground)
        requestUserGroups()
    }
    
    func backButtonTapped() {
        router.navigateToAccount()
    }
    
    func addGroupButtonSelected() {
        router.presentEnterGroupName()
    }
    
    func addGroupToTable(_ group: Group) {
        groupsTable?.groups.append(group)
        originalGroups = groupsTable?.groups ?? []
        groupsTable?.reloadData()
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
            var userGroups: [Group] = []
            
            for groupJSON in jsonArray {
                if let group = Group(json: groupJSON) {
                    userGroups.append(group)
                }
            }
            
            DataManager.shared.setUserGroups(userGroups)
            
            let currGroupId = DataManager.shared.getCurrectGroupId()
            
            if let currentGroupIndex = userGroups.firstIndex(where: { $0.id == currGroupId }) {
                let currentGroup = userGroups[currentGroupIndex]
                DataManager.shared.setCurrentGroup(currentGroup)
            } else {
                DataManager.shared.resetCurrentGroup()
                DataManager.shared.setCurrentGroupToRandomUserGroup()
            }
            
            groupsTable?.groups = userGroups
            originalGroups = userGroups
            
            DispatchQueue.main.async { [weak self] in
                self?.groupsTable?.reloadData()
                LoadingView.hide(fromVC: self?.view)
            }
        } else {
            print("something went wrong - handleGetUserGroupsResponse")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
