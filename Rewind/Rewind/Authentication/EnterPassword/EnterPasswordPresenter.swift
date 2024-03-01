//
//  EnterPasswordPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

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
        DataManager.shared.setUserPassword(password)
        let process = DataManager.shared.getUserProcess()
        switch process {
        case .registration:
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
        NetworkService.logInUser(withEmail: email, password: password) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleLoginUserResponse(response, email: email)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension EnterPasswordPresenter {
    private func handleLoginUserResponse(_ response: NetworkResponse, email: String) {
        if response.success, let message = response.message, let userId = Int(message) {
            UserDefaults.standard.set(userId, forKey: "UserId")
            DataManager.shared.setUserId(userId)
            DispatchQueue.main.async {
                self.router.navigateToMainScreen()
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
