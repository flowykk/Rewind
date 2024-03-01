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
    
    func navigateToEditPassword(viewDistanceTop: CGFloat) {
        let vc = EditPasswordBuilder.build()
        vc.modalPresentationStyle = .custom
        vc.enterAuthCodeVC = view
        vc.viewDistanceTop = viewDistanceTop
        view?.present(vc, animated: true)
    }
}
