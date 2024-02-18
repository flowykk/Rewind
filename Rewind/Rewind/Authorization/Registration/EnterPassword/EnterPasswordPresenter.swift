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
    
    func backButtonTapped() {
        router.navigateToEnterCode()
    }
    
    func savePassword(password: String) {
        DataManager.shared.setUserPassword(password)
        router.navigateToEnterName()
    }
}
