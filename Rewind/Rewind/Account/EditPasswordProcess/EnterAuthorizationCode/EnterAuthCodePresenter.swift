//
//  EnterAuthCodePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation

final class EnterAuthCodePresenter {
    private weak var view: EnterAuthCodeViewController?
    private var router: EnterAuthCodeRouter
    
    init(view: EnterAuthCodeViewController?, router: EnterAuthCodeRouter) {
        self.view = view
        self.router = router
    }
    
    func validateCode(_ code: String) {
        let expectedCode = DataManager.shared.getUserVerificationCode()
        if expectedCode == code {
            let value = view?.viewDistanceTop ?? 40
            router.navigateToEditPassword(viewDistanceTop: value)
        } else {
            print("Wrong code")
        }
    }
}
