//
//  RewindRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 02.03.2024.
//

import UIKit

final class RewindRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToAccount() {
        let vc = AccountBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentSettings() {
        let vc = SettingsBuilder.build()
//        if let nc = view?.navigationController {
//            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
//        }
//        vc.delegate = view as? AccountViewController
        view?.present(vc, animated: true)
    }
}
