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
    
    func sendVerificationCode(toEmail email: String) {
        LoadingView.show(inVC: view)
        NetworkService.sendCodeToRegister(toEmail: email) { [weak self] response in
            DispatchQueue.main.async { [weak self] in
                if response.success {
                    let value = self?.view?.viewDistanceTop ?? 40
                    DataManager.shared.setUserVerificationCode(response.message ?? "")
                    self?.router.navigateToEnterVerificationCode(viewDistanceTop: value, newEmail: email)
                } else {
                    print(response.statusCode as Any)
                    print(response.message as Any)
                }
                LoadingView.hide(fromVC: self?.view)
            }
        }
    }
}
