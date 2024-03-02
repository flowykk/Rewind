//
//  AccountPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import Foundation
import UIKit

final class AccountPresenter {
    private weak var view: AccountViewController?
    weak var collectionView: AppIconCollectionView?
    
    private var router: AccountRouter
    
    init(view: AccountViewController?, router: AccountRouter) {
        self.view = view
        self.router = router
    }
    
    // MARK: - View To Presenter
    func backButtonTapped() {
        router.navigateToRewind()
    }
    
    func newImageSelected(image: String) {
        updateUserImage(withImage: image)
    }
    
    func copyEmailToPasteboard() {
        UIPasteboard.general.string = "sent@rewindapp.ru"
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "UserId")
        router.navigateToWellcome()
    }
    
    func deleteAccount() {
        let userId = DataManager.shared.getUserId()
        NetworkService.deleteUser(withId: userId) { response in
            DispatchQueue.main.async {
                if response.success {
                    print("User deleted")
                    print("Id: \(response.message as Any)")
                    UserDefaults.standard.removeObject(forKey: "UserId")
                    DataManager.shared.setUserId(-1)
                    self.router.navigateToWellcome()
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
            }
        }
    }
    
    func didUpdateName(to newName: String) {
        view?.setUserName(to: newName)
    }
    
    // MARK: - CollectionView To Presenter
    func appIconSelected(_ icon: AppIcon, at index: Int) {
        if icon == .AppIconWhite {
            UIApplication.shared.setAlternateIconName(nil)
        } else {
            UIApplication.shared.setAlternateIconName(icon.rawValue)
        }
        updateSelection(idnex: index)
    }
    
    // MARK: - GroupsTableView To Presenter
    func groupsRowSelected(_ row: GroupsTableView.GroupsRow) {
        switch row {
        case .viewGroups:   print("show all groups")
        }
    }
    
    // MARK: - GeneralTableView To Presenter
    func generalRowSelected(_ row: GeneralTableView.GeneralRow) {
        switch row {
        case .editImage:    openEditImageAlert()
            
        case .editName:     router.presentEditName()
            
        case .editEmail:    router.presentEditEmail()
            
        case .editPassword: let userEmail = DataManager.shared.getUserEmail()
            sendAuthenticationCode(toEmail: userEmail)
            router.presentEnterAuthCode()
            
        case .getHelp:      openHelpAlert()
            
        case .share:        router.presentShareVC()
        }
    }
    
    // MARK: - RiskyZoneTableView To Presenter
    func riskyZoneRowSelected(_ row: RiskyZoneTableView.RiskyZoneRow) {
        switch row {
        case .logOut:        openLogOutConfirmationAlert()
        case .deleteAccount: openDeleteAccountConfirmationAlert()
        }
    }
    
    // MARK: - Presenter To View
    func viewDidLoad() {
        if let avatarImage = imageFromBase64String(base64String: DataManager.shared.getAvatarBase64String()) {
            view?.setAvatarImage(to: avatarImage)
        }
        
        let userName = DataManager.shared.getUserName()
        if userName == "" {
        }
        view?.setUserName(to: userName)
        
        let currentIconName = UIApplication.shared.alternateIconName ?? "AppIconWhite"
        AppIconCell.initialSelectedIcon = currentIconName
        
        let index = AppIcon.indexForCase(withValue: currentIconName) ?? 0
        collectionView?.selectedAppIconIndexPath = IndexPath(item: index, section: 0)
    }
    
    func didUpdateImage(to image: String) {
        if let avatarImage = imageFromBase64String(base64String: image) {
            view?.setAvatarImage(to: avatarImage)
        }
    }
    
    func openEditImageAlert() {
        view?.showEditImageAlert()
    }
    
    func openHelpAlert() {
        view?.showHelpAlert()
    }
    
    func openLogOutConfirmationAlert() {
        view?.showLogOutConfirmationAlert()
    }
    
    func openDeleteAccountConfirmationAlert() {
        view?.showDeleteAccountConfirmationAlert()
    }
    
    func openPhotoGallery() {
        view?.showImagePicker()
    }
    
    // MARK: - Presenter to CollectionView
    func updateSelection(idnex: Int) {
        collectionView?.updateSelectedCell(at: idnex)
    }
}

// MARK: - Network Request Funcs
extension AccountPresenter {
    private func sendAuthenticationCode(toEmail email: String) {
        NetworkService.sendCode(toEmail: email) { response in
            DispatchQueue.global().async {
                if response.success {
                    if let message = response.message {
                        if let code = Int(message) {
                            DataManager.shared.setUserVerificationCode("\(code)")
                        }
                    }
                } else {
                    print(response.statusCode as Any)
                    print(response.message as Any)
                }
            }
        }
    }
    
    private func updateUserImage(withImage newImage: String) {
        let userId = DataManager.shared.getUserId()
        NetworkService.updateUserImage(userId: userId, newImage: newImage) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleUpdateUserImageResponse(response, image: newImage)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension AccountPresenter {
    private func handleUpdateUserImageResponse(_ response: NetworkResponse, image: String) {
        if response.success {
            DataManager.shared.setUserImageBase64String(image)
            DispatchQueue.main.async {
                self.didUpdateImage(to: image)
            }
        }
    }
}

// MARK: - Utility Functions
extension AccountPresenter {
    private func imageFromBase64String(base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        guard let image = UIImage(data: imageData) else { return nil }
        return image
    }
}
