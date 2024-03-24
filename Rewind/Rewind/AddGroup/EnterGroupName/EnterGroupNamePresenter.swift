//
//  EnterGroupNamePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation

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
                LoadingView.hide(from: self?.view)
                self?.view?.dismiss(animated: true)
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
