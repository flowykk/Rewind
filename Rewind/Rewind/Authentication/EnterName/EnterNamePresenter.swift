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
        NetworkService.registerUser(user: DataManager.shared.getUser()) { response in
            DispatchQueue.main.async {
                if response.success {
                    if let message = response.message, let userId = Int(message)  {
                        UserDefaults.standard.set(userId, forKey: "UserId")
                        DataManager.shared.setUserId(userId)
                        self.router.navigateToMainScreen()
                    }
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
            }
        }
    }
}
