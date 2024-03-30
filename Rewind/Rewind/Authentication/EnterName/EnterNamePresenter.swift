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
                self?.handleRegisterUserResponse(response)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension EnterNamePresenter {
    private func handleRegisterUserResponse(_ response: NetworkResponse) {
        if response.success,
           let json = response.json,
           let id = json["id"] as? Int,
           let name = json["userName"] as? String,
           let email = json["email"] as? String,
           let regDateString = json["registrationDateTime"] as? String
        {
            UserDefaults.standard.set(id, forKey: "UserId")
            UserDefaults.standard.set(name, forKey: "UserName")
            UserDefaults.standard.set(email, forKey: "UserEmail")
            UserDefaults.standard.set(regDateString, forKey: "UserRegDate")
            
            DispatchQueue.main.async { [weak self] in
                self?.router.navigateToRewind()
            }
        } else {
            print(response.statusCode as Any)
            print(response.message as Any)
        }
    }
}
