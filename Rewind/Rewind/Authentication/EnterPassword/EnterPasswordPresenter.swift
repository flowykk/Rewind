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
    
    func continueButtonTapped(password: String?) {
        guard let password = password, Validator.isValidPassword(password) else {
            AlertHelper.showAlert(from: view, withTitle: "Error", message: "Incorrect password")
            return
        }
        
        let process = DataManager.shared.getUserProcess()
        let encryptedPassword = password.sha256()
        switch process {
        case .registration:
            DataManager.shared.setUserPassword(encryptedPassword)
            router.navigateToEnterName()
        case .authorization:
            LoadingView.show(inVC: view)
            let email = DataManager.shared.getUserEmail()
            loginUser(withEmail: email, password: encryptedPassword)
        default:
            // TODO: something
            return
        }
    }
    
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
            
            if let imageB64String = json["profileImage"] as? String {
                let image = UIImage(base64String: imageB64String)
                if let imageData = image?.jpegData(compressionQuality: 1) {
                    UserDefaults.standard.setImage(imageData, forKey: "UserImage")
                }
            }
            
            if let imageB64String = json["tinyProfileImage"] as? String {
                let image = UIImage(base64String: imageB64String)
                if let imageData = image?.jpegData(compressionQuality: 1) {
                    UserDefaults.standard.setImage(imageData, forKey: "UserMiniImage")
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToRewind()
            }
        } else {
            var message = response.message ?? "Something went wrong"
            if response.statusCode == 400 {
                message = "Incorrect password or unregistered email address"
            }
            print("something went wrong - handleLoginUserResponse")
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
