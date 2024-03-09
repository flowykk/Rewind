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
    
    func navigateToGroup() {
        let vc = GroupViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
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
            let button = rewindView.showGroupsMenuButton
            
            vc.popoverPresentationController?.sourceView = button
            vc.popoverPresentationController?.sourceRect = CGRect(x: button.bounds.midX, y: button.bounds.maxY + 2, width: 0, height: 0)
            rewindView.present(vc, animated: true)
        }
    }
}
