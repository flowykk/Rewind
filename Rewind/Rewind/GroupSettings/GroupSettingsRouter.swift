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
    
    func navigateToRewind() {
        if let navigationController = view?.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is RewindViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = view as? GroupSettingsViewController
        view?.present(imagePickerController, animated: true) {
            LoadingView.hide(fromVC: self.view)
        }
    }
    
    func presentEditGroupName() {
        let vc = EditGroupNameBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        if let groupSettingsView = view as? GroupSettingsViewController {
            vc.groupSettingVC = groupSettingsView
        }
        view?.present(vc, animated: true)
    }
    
    func presentEditImageAlert() {
        let alertController = UIAlertController(
            title: "Load your media",
            message: "This media will be visible to all members",
            preferredStyle: .alert)
        let chooseImageAction = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            if let groupSettingVC = self?.view as? GroupSettingsViewController {
                LoadingView.show(inVC: groupSettingVC)
                groupSettingVC.presenter?.openPhotoLibraryButtonTapped()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(chooseImageAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
    
    func presentLeaveGroupConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Confirm Leaving Group",
            message: "Are you sure you want to leave the group? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { [weak self] _ in
            if let groupSettingsVC = self?.view as? GroupSettingsViewController {
                groupSettingsVC.presenter?.removeUserFromGroup()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
    
    func presentDeleteGroupConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Confirm Group Deletion",
            message: "Are you sure you want to delete the group? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            if let groupSettingsVC = self?.view as? GroupSettingsViewController {
                groupSettingsVC.presenter?.deleteGroup()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        view?.present(alertController, animated: true)
    }
}
