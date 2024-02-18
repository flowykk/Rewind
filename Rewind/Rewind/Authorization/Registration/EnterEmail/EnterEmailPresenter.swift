//
//  EnterEmailPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterEmailPresenter {
    private weak var view: EnterEmailViewController?
    private var router: EnterEmailRouter
    
    init(view: EnterEmailViewController?, router: EnterEmailRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToWellcome()
    }
    
    func sendVerificationCode(toEmail email: String) {
        NetworkService.sendVerificationCode(toEmail: email) { response in
            DispatchQueue.main.async {
                if response.success {
                    self.router.navigateToEnterCode()
                    DataManager.shared.setUserEmail(email)
                    DataManager.shared.setUserVerificationCode(response.message ?? "")
                    print(response.message as Any)
                } else {
                    print(response.success)
                }
            }
        }
    }
}
