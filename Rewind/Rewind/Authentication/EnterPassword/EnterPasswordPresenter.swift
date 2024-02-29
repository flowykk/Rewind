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
            let user = DataManager.shared.getUser()
            authorizeUser(user: user)
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

// MARK: - Private funcs
extension EnterPasswordPresenter {
    private func authorizeUser(user: User) {
        NetworkService.authorizeUser(user: DataManager.shared.getUser()) { response in
            DispatchQueue.main.async {
                if response.success {
                    print("User logged in")
                    print("Id: \(response.message as Any)")
                    if let message = response.message, let userId = Int(message)  {
                        UserDefaults.standard.set(userId, forKey: "UserId")
                        self.router.navigateToMainScreen()
                    }
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
                self.view?.hideLoadingView()
            }
        }
    }
}
