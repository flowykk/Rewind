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
        view?.present(vc, animated: true)
    }
    
    func navigateToDetails() {
        let vc = DetailsBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentGroupsMenu() {
        let vc = GroupsMenuViewController()
        
        vc.rowSelectionHandler = { [weak self] row in
            print(row)
            vc.dismiss(animated: true)
            if let rewindView = self?.view as? RewindViewController {
                if row != "All groups" {
                    rewindView.setCurrentGroup(to: row)
                }
            }
        }
        
        vc.modalPresentationStyle = .popover
        
        let height = Double((1 + 4) * 40)
        
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width / 2, height: height)
        
        vc.popoverPresentationController?.delegate = vc
        vc.popoverPresentationController?.permittedArrowDirections = .up
        
        if let rewindView = view as? RewindViewController {
            vc.popoverPresentationController?.sourceView = rewindView.showGroupsMenuButton
            vc.popoverPresentationController?.sourceRect = rewindView.showGroupsMenuButton.bounds
            rewindView.present(vc, animated: true)
        }
    }
}
