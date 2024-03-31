//
//  AccountRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class AccountRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToAllGroups() {
        let vc = AllGroupsBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToWellcome() {
        let vc = WellcomeBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRewind() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentEditImageAlert() {
        let alertController = UIAlertController(
            title: "Load your media",
            message: "This media will be visible to all people",
            preferredStyle: .alert)
        let chooseImageAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            if let accountVC = self.view as? AccountViewController {
                accountVC.presenter?.openPhotoLibraryButtonTapped()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(chooseImageAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = view as? AccountViewController
        view?.present(imagePickerController, animated: true) {
            LoadingView.hide(fromVC: self.view)
        }
    }
    
    func presentEditName() {
        let vc = EditNameBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        vc.accountVC = view as? AccountViewController
        view?.present(vc, animated: true)
    }
    
    func presentEditEmail() {
        let vc = EditEmailBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        if let accountVC = view as? AccountViewController {
            vc.accountVC = accountVC
        }
        view?.present(vc, animated: true)
    }
    
    func presentEnterAuthCode() {
        let vc = EnterAuthCodeBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        view?.present(vc, animated: true)
    }
    
    func presentHelpAlert() {
        let alertController = UIAlertController(
            title: "Contact Us",
            message: "If you want to ask questions, you faced some other problems, or you have new ideas for Rewind just email us on sent@rewindapp.ru",
            preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Copy our email", style: .default) { _ in
            if let accountVC = self.view as? AccountViewController {
                accountVC.presenter?.copyEmailToPasteboard()
            }
        }
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
    
    func presentShareVC() {
        guard let appURL = URL(string: "https://www.rewindapp.ru") else { return }
        
        let vc = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        vc.excludedActivityTypes = [.addToReadingList, .assignToContact, .print,]
        
        view?.present(vc, animated: true) { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
    
    func presentLogOutConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Confirm Log Out",
            message: "Are you sure you want to log out? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            if let accountVC = self.view as? AccountViewController {
                accountVC.presenter?.logOut()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
    
    func presentDeleteAccountConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Confirm Account Deletion",
            message: "Are you sure you want to delete your account? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            if let accountVC = self.view as? AccountViewController {
                accountVC.presenter?.deleteAccount()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
}
