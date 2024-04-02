//
//  EditPasswordPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation

final class EditPasswordPresenter {
    private weak var view: EditPasswordViewController?
    
    init(view: EditPasswordViewController) {
        self.view = view
    }
    
    func updatePassword(with newPassword: String?) {
        guard let newPassword = newPassword, Validator.isValidPassword(newPassword) else {
            AlertHelper.showAlert(from: view, withTitle: "Error", message: "Invalid password")
            return
        }
        
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        let encryptedPassword = newPassword.sha256()
        NetworkService.updateUserPassword(userId: userId, newPassword: encryptedPassword) { response in
            DispatchQueue.main.async { [weak self] in
                self?.view?.dismiss(animated: true, completion: {
                    self?.view?.enterAuthCodeVC?.dismiss(animated: true)
                })
            }
        }
    }
}
