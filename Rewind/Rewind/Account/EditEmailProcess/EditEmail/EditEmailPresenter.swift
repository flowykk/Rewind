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
    
    func sendVerificationVode(toEmail email: String) {
        NetworkService.sendCodeToRegister(toEmail: email) { response in
            DispatchQueue.main.async {
                if response.success {
                    let value = self.view?.viewDistanceTop ?? 40
                    DataManager.shared.setUserVerificationCode(response.message ?? "")
                    self.router.navigateToEnterVerificationCode(viewDistanceTop: value, newEmail: email)
                } else {
                    print(response.statusCode as Any)
                    print(response.message as Any)
                }
            }
        }
    }
}
