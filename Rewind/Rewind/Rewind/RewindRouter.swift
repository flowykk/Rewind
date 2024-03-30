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
        
        if let navigationBar = rewindView.navigationController?.navigationBar {
            vc.popoverPresentationController?.sourceView = navigationBar
            let titleViewCenter = CGPoint(x: navigationBar.bounds.midX, y: navigationBar.bounds.maxY)
            vc.popoverPresentationController?.sourceRect = CGRect(origin: titleViewCenter, size: .zero)
        }
        
        rewindView.present(vc, animated: true)
    }
    
    func presentEnterGroupName() {
        guard let groupsMenuVC = view?.presentedViewController else { return }
        groupsMenuVC.dismiss(animated: true)
        
        let vc = EnterGroupNameBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        
        vc.rewindVC = view as? RewindViewController
        view?.present(vc, animated: true)
    }
    
    func navigateToGroup() {
        let vc = GroupBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
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
        vc.modalPresentationStyle = .custom
        
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        
        if let rewindVC = view as? RewindViewController {
            vc.rewindVC = rewindVC
        }
        
        view?.present(vc, animated: true)
    }
    
    func navigateToDetails() {
        let vc = DetailsBuilder.build()
        if let rewindVC = view as? RewindViewController {
            vc.rewindVC = rewindVC
            vc.mediaId = rewindVC.randomMediaId
        }
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToGallery() {
        let vc = GalleryBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
