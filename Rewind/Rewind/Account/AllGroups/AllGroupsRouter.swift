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
    
    func navigateToAddGroup() {
        let vc = EnterGroupNameBuilder.build()
        vc.allGroupsVCDelegate = view as? AllGroupsViewController
        view?.present(vc, animated: true)
    }
    
    func navigateToRewind() {
        let vc = RewindBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
       
