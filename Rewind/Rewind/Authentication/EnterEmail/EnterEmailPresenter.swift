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
    
    func continueButtonTapped(email: String?) {
        guard let email = email, Validator.isValidEmail(email) else {
            AlertHelper.showAlert(from: view, withTitle: "Error", message: "Wrong email")
            return
        }
        
        LoadingView.show(inVC: view)
        
        let process = DataManager.shared.getUserProcess()
        switch process {
        case .registration:
            sendCodeToRegister(toEmail: email)
        case .authorization:
            checkEmailToLogin(email: email)
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
    
    private func checkEmailToLogin(email: String) {
        NetworkService.checkEmailToLogin(email: email) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleCheckEmailToLoginResponse(response, email: email)
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
            print(code)
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToEnterCode()
            }
        } else {
            let message = "User with this email address is already registered or something went wrong"
            print(#function, response)
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                AlertHelper.showAlert(from: self?.view, withTitle: "Error", message: message)
            }
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
    
    private func handleCheckEmailToLoginResponse(_ response: NetworkResponse, email: String) {
        if response.success {
            DataManager.shared.setUserEmail(email)
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToEnterPassword()
            }
        } else {
            var message = response.message ?? "Something went wrong"
            if response.statusCode == 400 {
                message = "User with this email address is not registered"
            }
            print(#function, response)
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                AlertHelper.showAlert(from: self?.view, withTitle: "Error", message: message)
            }
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
