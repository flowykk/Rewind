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
        print("Code: <\(code)>")
        view?.dismiss(animated: true) {
            self.view?.editEmailVC?.dismiss(animated: true)
        }
    }
}
