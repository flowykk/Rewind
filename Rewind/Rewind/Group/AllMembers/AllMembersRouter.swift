//
//  AllMembersRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import UIKit

final class AllMembersRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToGroup() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentDeleteMemberConfirmationAlert(memberId: Int) {
        let alertController = UIAlertController(
            title: "Confirm Member Deletion",
            message: "Are you sure you want to delete this member from group? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            if let allMembersVC = self?.view as? AllMembersViewController {
                allMembersVC.presenter?.deleteMember(withId: memberId)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
}
