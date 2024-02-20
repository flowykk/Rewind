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
    
    // MARK: - View To Presenter
    func backButtonTapped() {
        router.navigateToEnterCode()
    }
    
    func continueButtonTapped(password: String) {
        DataManager.shared.setUserPassword(password)
        let process = DataManager.shared.getUserProcess()
        switch process {
        case .registration:
            router.navigateToEnterName()
        case .authorization:
            view?.showLoadingView()
            let user = DataManager.shared.getUser()
            authorizeUser(user: user)
        default:
            // TODO: something
            return
        }
    }
}

// MARK: - Private funcs
extension EnterPasswordPresenter {
    private func authorizeUser(user: User) {
        NetworkService.authorizeUser(user: DataManager.shared.getUser()) { response in
            DispatchQueue.main.async {
                if response.success {
                    print(response.message as Any)
                    self.router.navigateToMainScreen()
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
                self.view?.hideLoadingView()
            }
        }
    }
}
