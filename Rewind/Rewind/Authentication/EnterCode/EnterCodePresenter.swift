//
//  EnterCodePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterCodePresenter {
    private weak var view: EnterCodeViewController?
    private var router: EnterCodeRouter
    
    init(view: EnterCodeViewController?, router: EnterCodeRouter) {
        self.view = view
        self.router = router
    }
    
    // MARK: - View To Presenter
    func backButtonTapped() {
        router.navigateToEnterEmail()
    }
    
    func validateCode(code: String) {
        if code == DataManager.shared.getUserVerificationCode() {
            router.navigateToEnterPassword()
        } else {
            // TODO: alert about wrong code
        }
    }
}
