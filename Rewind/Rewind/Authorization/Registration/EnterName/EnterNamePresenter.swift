//
//  EnterNamePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterNamePresenter {
    private weak var view: EnterNameViewController?
    private var router: EnterNameRouter
    
    init(view: EnterNameViewController?, router: EnterNameRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToEnterPassword()
    }
    
    func saveName(name: String) {
        DataManager.shared.setUserName(name)
        print(DataManager.shared.getUser())
        NetworkService.registerUser(user: DataManager.shared.getUser()) { response in
            if response.success {
                print("New user created")
                print(response.message as Any)
            } else {
                print(response.success)
            }
        }
    }
}
