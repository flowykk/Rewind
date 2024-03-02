//
//  EnterPasswordRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class EnterPasswordRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToEnterCode() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToEnterName() {
        let vc = EnterNameBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRewind() {
        let vc = ViewController()
        vc.navigationController?.isNavigationBarHidden = true
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
