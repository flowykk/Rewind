//
//  DetailsRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class DetailsRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToRewind() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToGallery() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentAddTag() {
        let vc = AddTagBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        if let detailsVC = view as? DetailsViewController {
            vc.detailsVC = detailsVC
            vc.existingTags = detailsVC.presenter?.tagsCollection?.tags
            vc.mediaId = detailsVC.mediaId
        }
        view?.present(vc, animated: true)
    }
    
    func presentDeleteMediaConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Confirm Media Deletion",
            message: "Are you sure you want to delete this media? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            if let detailsVC = self?.view as? DetailsViewController {
                detailsVC.presenter?.deleteMediaFromGroup()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
}
