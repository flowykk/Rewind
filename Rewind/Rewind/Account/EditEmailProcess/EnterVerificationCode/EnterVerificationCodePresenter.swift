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
            let userId = DataManager.shared.getUserId()
            if let newEmail = view?.newEmail {
                updateUserEmail(userId: userId, newEmail: newEmail)
            } else {
                // TODO: catch nil
            }
        }
    }
    
    var handleNetworkResponse = { (response: NetworkResponse) -> Void in
        if response.success {
            DispatchQueue.global().async {
                
            }
        }
    }
}

// MARK: - Private funcs
extension EnterVerificationCodePresenter {
    private func updateUserEmail(userId: Int, newEmail: String) {
        NetworkService.updateUserEmail(userId: userId, newEmail: newEmail) { response in
            DispatchQueue.main.async {
                if response.success {
                    
                }
            }
        }
    }
}
