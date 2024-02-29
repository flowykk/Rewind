//
//  AccountRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class AccountRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToRewind() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func showEditName() {
        let vc = EditNameBuilder.build()
        view?.present(vc, animated: true)
    }
    
    func showEnterAuthCode() {
        let vc = EnterAuthCodeBuilder.build()
        view?.present(vc, animated: true)
    }
    
    func showEditEmail() {
        let vc = EditEmailBuilder.build()
        view?.present(vc, animated: true)
    }
}
