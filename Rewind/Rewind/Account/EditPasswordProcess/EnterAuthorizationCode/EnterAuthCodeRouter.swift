//
//  EnterAuthCodeRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import UIKit

final class EnterAuthCodeRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToEditPassword() {
        let vc = EditPasswordBuilder.build()
        vc.modalPresentationStyle = .overCurrentContext
        vc.enterAuthCodeVC = view
        view?.present(vc, animated: true)
    }
}
