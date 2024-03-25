//
//  EnterGroupNameRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import UIKit

final class EnterGroupNameRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
//    func navigateToLoadGroupImage() {
//        let vc = LoadGroupImageBuilder.build()
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.enterGroupNameVC = view
//        view?.present(vc, animated: true)
//    }
    
    func navigateToGroup() {
        let vc = GroupBuilder.build()
        vc.modalTransitionStyle = .crossDissolve
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
