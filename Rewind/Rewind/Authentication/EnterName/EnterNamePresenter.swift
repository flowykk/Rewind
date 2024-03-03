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
        DataManager.shared.setUserName(name)
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
            DataManager.shared.setUserId(userId)
            saveUserDataToUserDefaults(user: DataManager.shared.getUser())
            DispatchQueue.main.async {
                self.router.navigateToRewind()
            }
        } else {
            print(response.statusCode as Any)
            print(response.message as Any)
        }
    }
}

// MARK: - Private Functions
extension EnterNamePresenter {
    private func saveUserDataToUserDefaults(user: User) {
        UserDefaults.standard.set(user.id, forKey: "UserId")
        UserDefaults.standard.set(user.name, forKey: "UserName")
        UserDefaults.standard.set(user.email, forKey: "UserEmail")
    }
}
