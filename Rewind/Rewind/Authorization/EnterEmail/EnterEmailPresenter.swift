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
    
    // MARK: - View To Presenter
    func backButtonTapped() {
        router.navigateToWellcome()
    }
    
    func continueButtonTapped(email: String) {
        view?.showLoadingView()
        let process = DataManager.shared.getUserProcess()
        switch process {
        case .registration:
            sendVerificationCode(toEmail: email)
        case .authorization:
            checkEmailExistence(email)
        default:
            // TODO: something
            return
        }
    }
}

// MARK: - Private funcs
extension EnterEmailPresenter {
    private func sendVerificationCode(toEmail email: String) {
        NetworkService.sendVerificationCode(toEmail: email) { response in
            DispatchQueue.main.async {
                if response.success {
                    print(response.message as Any)
                    DataManager.shared.setUserEmail(email)
                    DataManager.shared.setUserVerificationCode(response.message ?? "")
                    self.router.navigateToEnterCode()
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
                self.view?.hideLoadingView()
            }
        }
    }
    
    private func checkEmailExistence(_ email: String) {
        NetworkService.checkEmailExistence(email) { response in
            DispatchQueue.main.async {
                if response.success {
                    print(response.message as Any)
                    DataManager.shared.setUserEmail(email)
                    self.router.navigateToEnterPassword()
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
                self.view?.hideLoadingView()
            }
        }
    }
}
