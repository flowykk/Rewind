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
        let vc = GroupBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentGroupsMenu() {
        let vc = GroupsMenuViewController()
        guard let rewindView = view as? RewindViewController else { return }
        vc.presenter = rewindView.presenter
        
        vc.modalPresentationStyle = .popover
        
        let buttonsQuantity = GroupsMenuTableView.GroupsMenuButton.allCases.count
        let groupsQuantity = DataManager.shared.getUserGroups().count
        let totalRows = min(GroupsMenuTableView.rowsLimit, buttonsQuantity + groupsQuantity)
        let rowHeight = vc.groupsMenuTable.rowHeight
        
        let height = Double(totalRows * Int(rowHeight) - (totalRows > 0 ? 1 : 0))
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.6, height: height)
        
        vc.popoverPresentationController?.delegate = vc
        vc.popoverPresentationController?.permittedArrowDirections = .up
        
        if let rewindView = view as? RewindViewController {
            let button = rewindView.showGroupsMenuButton
            vc.popoverPresentationController?.sourceView = button
            vc.popoverPresentationController?.sourceRect = CGRect(x: button.bounds.midX, y: button.bounds.maxY + 2, width: 0, height: 0)
            rewindView.present(vc, animated: true)
        }
    }
    
    func navigateToAllGroups() {
        let vc = AllGroupsBuilder.build()
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
    
    func navigateToGallery() {
        let vc = GalleryBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
