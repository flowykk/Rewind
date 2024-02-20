//
//  EnterEmailRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class EnterEmailRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToWellcome() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToEnterCode() {
        let vc = EnterCodeBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToEnterPassword() {
        let vc = EnterPasswordBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
