//
//  EditEmailRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.02.2024.
//

import UIKit

final class EditEmailRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToEnterVerificationCode(viewDistanceTop: CGFloat) {
        let vc = EnterVerificationCodeBuilder.build()
        vc.modalPresentationStyle = .custom
        vc.editEmailVC = view
        vc.viewDistanceTop = viewDistanceTop
        view?.present(vc, animated: true)
    }
}
