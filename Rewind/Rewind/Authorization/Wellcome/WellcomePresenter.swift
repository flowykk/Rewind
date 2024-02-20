//
//  WellcomePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class WellcomePresenter {
    private weak var view: WellcomeViewController?
    private var router: WellcomeRouter
    
    init(view: WellcomeViewController?, router: WellcomeRouter) {
        self.view = view
        self.router = router
    }
    
    func registerButtonTapped() {
        DataManager.shared.setUserProcess(.registration)
        router.navigateToEnterEmail()
    }
    
    func loginButtonTapped() {
        DataManager.shared.setUserProcess(.authorization)
        router.navigateToEnterEmail()
    }
}
