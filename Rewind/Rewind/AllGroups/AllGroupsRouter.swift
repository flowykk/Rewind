//
//  AllGroupsRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import UIKit

final class AllGroupsRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToAccount() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentEnterGroupName() {
        let vc = EnterGroupNameBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        vc.allGroupsVCDelegate = view as? AllGroupsViewController
        view?.present(vc, animated: true)
    }
    
    func navigateToRewind() {
        if let navigationController = view?.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is RewindViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
}
