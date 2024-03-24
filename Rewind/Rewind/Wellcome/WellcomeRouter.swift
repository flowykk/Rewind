//
//  WellcomeRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class WellcomeRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToEnterEmail() {
        let vc = EnterEmailBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
