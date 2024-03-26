//
//  RewindPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 02.03.2024.
//

import Foundation
import Photos
import UIKit

final class RewindPresenter {
    private weak var view: RewindViewController?
    weak var groupsMenuTable: GroupsMenuTableView?
    private var router: RewindRouter
    
    init(view: RewindViewController?, router: RewindRouter) {
        self.view = view
        self.router = router
    }
    
    func goToGroup() {
        router.navigateToGroup()
    }
    
    func showGroupsMenuButtonTapped() {
        router.presentGroupsMenu()
    }
    
    func goToAccount() {
        router.navigateToAccount()
    }
    
    func settingsButtonTapped() {
        router.presentSettings()
    }
    
    func detailsButtonTapped() {
        router.navigateToDetails()
    }
    
    func downloadButtonTapped(currentImage: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAsset(from: currentImage)}, completionHandler: { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.view?.showSuccessAlert()
                        } else if let error = error {
                            self.view?.showErrorAlert(message: error.localizedDescription)
                        }
                    }
                })
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Access to the gallery is denied or restricted")
                }
            case .limited:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Access to the gallery is limited")
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Access to the gallery is not determined")
                }
            @unknown default:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Something went wrong")
                }
            }
        }
    }
    
    func favouriteButtonTapped(favourite: Bool) {
        view?.isFavourite = !favourite
        if !favourite {
            view?.setFavouriteButton(imageName: "heart.fill", tintColor: .customPink)
        } else {
            view?.setFavouriteButton(imageName: "heart", tintColor: .systemGray2)
        }
    }
    
    func galleryButtonTapped() {
        router.navigateToGallery()
    }
    
    func buttonSelected(_ button: GroupsMenuTableView.GroupsMenuButton) {
        switch button {
        case .allGroups:
            router.navigateToAllGroups()
        case .addGroup:
            print("add group")
        }
    }
    
    func groupSelected(_ group: Group) {
        DataManager.shared.setCurrentGroup(group)
        view?.setCurrentGroup(to: group)
    }
}
