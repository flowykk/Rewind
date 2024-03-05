//
//  EnterPasswordPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation
import UIKit

final class EnterPasswordPresenter {
    private weak var view: EnterPasswordViewController?
    private var router: EnterPasswordRouter
    
    init(view: EnterPasswordViewController?, router: EnterPasswordRouter) {
        self.view = view
        self.router = router
    }
    
    // MARK: - View To Presenter
    func viewDidLoad() {
        let process = DataManager.shared.getUserProcess()
        var text = ""
        var decision = false
        if process == .registration {
            text = "Choose a password"
        } else if process == .authorization {
            text = "Enter your password"
            decision = true
        }
        configureLabel(withText: text)
        configureShowForgotPasswordButton(withDecision: decision)
    }
    
    func backButtonTapped() {
        router.navigateToEnterCode()
    }
    
    func continueButtonTapped(password: String) {
        let process = DataManager.shared.getUserProcess()
        switch process {
        case .registration:
            DataManager.shared.setUserPassword(password)
            router.navigateToEnterName()
        case .authorization:
            view?.showLoadingView()
            let email = DataManager.shared.getUserEmail()
            loginUser(withEmail: email, password: password)
        default:
            // TODO: something
            return
        }
    }
    
    // MARK: - Presenter To View
    func configureLabel(withText text: String) {
        view?.configureLabel(withText: text)
    }
    
    func configureShowForgotPasswordButton(withDecision decision: Bool) {
        view?.configureForgotPasswordButton(withDecision: decision)
    }
}

// MARK: - Network Request Funcs
extension EnterPasswordPresenter {
    private func loginUser(withEmail email: String, password: String) {
        NetworkService.loginUser(withEmail: email, password: password) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleLoginUserResponse(response)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension EnterPasswordPresenter {
    private func handleLoginUserResponse(_ response: NetworkResponse) {
        if response.success, let json = response.json {
            if
                let id = json["id"] as? Int,
                let name = json["userName"] as? String,
                let email = json["email"] as? String,
                let regDateString = json["registrationDateTime"] as? String
            {
                UserDefaults.standard.set(id, forKey: "UserId")
                UserDefaults.standard.set(name, forKey: "UserName")
                UserDefaults.standard.set(email, forKey: "UserEmail")
                UserDefaults.standard.set(regDateString, forKey: "UserRegDate")
                
                DispatchQueue.main.async {
                    self.view?.hideLoadingView()
                    self.router.navigateToRewind()
                }
            } else {
                print(response.statusCode as Any)
                print(response.message as Any)
            }
            
            DispatchQueue.main.async {
                self.view?.hideLoadingView()
            }
        }
    }
}
