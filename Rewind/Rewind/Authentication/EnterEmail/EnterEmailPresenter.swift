//
//  EnterEmailPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterEmailPresenter {
    private weak var view: EnterEmailViewController?
    private var router: EnterEmailRouter
    
    init(view: EnterEmailViewController?, router: EnterEmailRouter) {
        self.view = view
        self.router = router
    }
    
    // MARK: - View To Presenter
    func backButtonTapped() {
        router.navigateToWellcome()
    }
    
    func continueButtonTapped(email: String) {
        view?.showLoadingView()
        let process = DataManager.shared.getUserProcess()
        switch process {
        case .registration:
            sendCodeToRegister(toEmail: email)
        case .authorization:
            sendCodeToLogin(toEmail: email)
        default:
            // TODO: something
            return
        }
    }
}

// MARK: - Network Request Funcs
extension EnterEmailPresenter {
    private func sendCodeToRegister(toEmail email: String) {
        NetworkService.sendCodeToRegister(toEmail: email) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleSendCodeToRegisterResponse(response, email: email)
            }
        }
    }
    
    private func sendCodeToLogin(toEmail email: String) {
        NetworkService.sendCodeToLogIn(email) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleSendCodeToLoginResponse(response, email: email)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension EnterEmailPresenter {
    private func handleSendCodeToRegisterResponse(_ response: NetworkResponse, email: String) {
        if response.success, let message = response.message, let code = Int(message) {
            DataManager.shared.setUserEmail(email)
            DataManager.shared.setUserVerificationCode("\(code)")
            DispatchQueue.main.async {
                self.router.navigateToEnterCode()
            }
        } else {
            print(response.statusCode as Any)
            print(response.message as Any)
        }
        DispatchQueue.main.async {
            self.view?.hideLoadingView()
        }
    }
    
    private func handleSendCodeToLoginResponse(_ response: NetworkResponse, email: String) {
        if response.success {
            DataManager.shared.setUserEmail(email)
            DispatchQueue.main.async {
                self.router.navigateToEnterPassword()
            }
        } else {
            print(response.message as Any)
            print(response.statusCode as Any)
        }
        DispatchQueue.main.async {
            self.view?.hideLoadingView()
        }
    }
}
