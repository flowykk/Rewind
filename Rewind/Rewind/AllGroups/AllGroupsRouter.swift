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
    
    func goToCurrentGroupAfterAdding() {
        let vc = GroupBuilder.build()
        if let navigationController = view?.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is RewindViewController {
                    if let rewindVC  = viewController as? RewindViewController {
                        rewindVC.configureUIForRandomMedia(nil)
                    }
                    navigationController.popToViewController(viewController, animated: true)
                    viewController.navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        }
    }
    
    func presentEnterGroupName() {
        let vc = EnterGroupNameBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        vc.allGroupsVC = view as? AllGroupsViewController
        view?.present(vc, animated: true)
    }
    
    func navigateToRewind() {
        if let navigationController = view?.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is RewindViewController {
                    if let rewindVC  = viewController as? RewindViewController {
                        rewindVC.presenter?.getRandomMedia()
                    }
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
}
