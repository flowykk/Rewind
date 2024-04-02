//
//  EnterNameRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class EnterNameRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToEnterPassword() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToRewind() {
        let vc = RewindBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
