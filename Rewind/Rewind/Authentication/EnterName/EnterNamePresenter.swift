//
//  EnterNamePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterNamePresenter {
    private weak var view: EnterNameViewController?
    private var router: EnterNameRouter
    
    init(view: EnterNameViewController?, router: EnterNameRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToEnterPassword()
    }
    
    func saveName(name: String) {
        registerUser(withName: name)
    }
}

// MARK: - Network Request Funcs
extension EnterNamePresenter {
    private func registerUser(withName name: String) {
        let email = DataManager.shared.getUserEmail()
        let password = DataManager.shared.getUserPassword()
        NetworkService.registerUser(withName: name, email: email, password: password) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleRegisterUserResponse(response, name: name)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension EnterNamePresenter {
    private func handleRegisterUserResponse(_ response: NetworkResponse, name: String) {
        if response.success, let message = response.message, let userId = Int(message) {
            UserDefaults.standard.set(userId, forKey: "UserId")
            DataManager.shared.setUserName(name)
            DataManager.shared.setUserId(userId)
            DispatchQueue.main.async {
                self.router.navigateToRewind()
            }
        } else {
            print(response.statusCode as Any)
            print(response.message as Any)
        }
    }
}
