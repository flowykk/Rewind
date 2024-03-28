//
//  GroupRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import UIKit

final class GroupRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToRewind() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToGroupSettings() {
        let vc = GroupSettingsBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAllMembers() {
        let vc = AllMembersBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToGallery() {
        let vc = GalleryBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentShareLinkViewController() {
        guard let groupId = DataManager.shared.getCurrectGroupId() else { return }
        
        guard let joinLink = JoinLinkService.createJoinLink(groupId: groupId) else { return }
        
        let vc = UIActivityViewController(activityItems: [joinLink], applicationActivities: nil)
        vc.excludedActivityTypes = [.addToReadingList, .assignToContact, .print]
        
        view?.present(vc, animated: true) { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
    
    func presentDeleteMemberConfirmationAlert(memberId: Int) {
        let alertController = UIAlertController(
            title: "Confirm Member Deletion",
            message: "Are you sure you want to delete this member from group? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            if let groupVC = self?.view as? GroupViewController {
                groupVC.presenter?.removeMemberFromGroup(memberId: memberId)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
}
