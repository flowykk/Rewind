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
    
    func updatePassword(with newPassword: String) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.updateUserPassword(userId: userId, newPassword: newPassword) { response in
            DispatchQueue.main.async { [weak self] in
                self?.view?.dismiss(animated: true, completion: {
                    self?.view?.enterAuthCodeVC?.dismiss(animated: true)
                })
            }
        }
    }
}
