//
//  EnterVerificationCodePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.02.2024.
//

import Foundation

final class EnterVerificationCodePresenter {
    private weak var view: EnterVerificationCodeViewController?
    
    init(view: EnterVerificationCodeViewController?) {
        self.view = view
    }
    
    func validateCode(_ code: String) {
        let expectedCode = DataManager.shared.getUserVerificationCode()
        if expectedCode == code {
            if let newEmail = view?.newEmail {
                updateUserEmail(newEmail: newEmail)
            } else {
                // TODO: catch nil
            }
        }
    }
}

// MARK: - Private funcs
extension EnterVerificationCodePresenter {
    private func updateUserEmail(newEmail: String) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.updateUserEmail(userId: userId, newEmail: newEmail) { response in
            DispatchQueue.global().async {
                if response.success {
                    UserDefaults.standard.set(newEmail, forKey: "UserEmail")
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.dismiss(animated: true, completion: {
                            self?.view?.editEmailVC?.dismiss(animated: true)
                        })
                    }
                } else {
                    print(response.statusCode as Any)
                    print(response.message as Any)
                }
            }
        }
    }
}
