//
//  EnterGroupNamePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation
import UIKit

final class EnterGroupNamePresenter {
    private weak var view: EnterGroupNameViewController?
    private var router: EnterGroupNameRouter
    
    init(view: EnterGroupNameViewController?, router: EnterGroupNameRouter) {
        self.view = view
        self.router = router
    }
    
    func continueButtonTapped(groupName: String) {
        LoadingView.show(in: view)
        createGroup(withName: groupName)
    }
}

// MARK: - Network Request Funcs
extension EnterGroupNamePresenter {
    private func createGroup(withName groupName: String) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.createGroup(ownerId: userId, groupName: groupName) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleCreateGroupResponse(response, groupName: groupName)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension EnterGroupNamePresenter {
    private func handleCreateGroupResponse(_ response: NetworkResponse, groupName: String) {
        if response.success {
            DispatchQueue.main.async { [weak self] in
                self?.view?.allGroupsVCDelegate?.presenter?.addGroup(groupName: groupName)
                let userId = UserDefaults.standard.integer(forKey: "UserId")
                DataManager.shared.setCurrentGroup(Group(id: -1, name: groupName, ownerId: userId))
                LoadingView.hide(from: self?.view)
                self?.router.navigateToGroup()
            }
        } else {
            print("Error:   handleCreateGroupResponse")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
            self?.view?.dismiss(animated: true)
        }
    }
}
