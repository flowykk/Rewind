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
        print("Code: <\(code)>")
        router.navigateToEditPassword()
    }
}
