//
//  EditEmailPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.02.2024.
//

import Foundation

final class EditEmailPresenter {
    private weak var view: EditEmailViewController?
    private var router: EditEmailRouter
    
    init(view: EditEmailViewController?, router: EditEmailRouter) {
        self.view = view
        self.router = router
    }
    
    func updateEmail(with email: String) {
        print("New email: <\(email)>")
        router.navigateToEnterVerificationCode()
    }
}
