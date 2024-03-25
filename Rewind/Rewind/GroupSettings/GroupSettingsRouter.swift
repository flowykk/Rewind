//
//  GroupSettingsRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import UIKit

final class GroupSettingsRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToGroup() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentEditGroupName() {
        let vc = EditGroupNameBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        if let groupSettingsView = view as? GroupSettingsViewController {
            vc.groupSettingPresenter = groupSettingsView.presenter
        }
        view?.present(vc, animated: true)
    }
}
