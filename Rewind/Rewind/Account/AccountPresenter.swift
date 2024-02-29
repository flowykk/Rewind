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
    
    func newImageSelected(_ image: UIImage) {
        view?.setAvatarImage(image: image)
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
    
    // MARK: - CollectionView To Presenter
    func appIconSelected(_ icon: AppIcon, at index: Int) {
        if icon == .AppIconWhite {
            UIApplication.shared.setAlternateIconName(nil)
        } else {
            UIApplication.shared.setAlternateIconName(icon.rawValue)
        }
        updateSelection(idnex: index)
    }
    
    // MARK: - GeneralTableView To Presenter
    func generalRowSelected(_ row: GeneralTableView.GeneralRow) {
        switch row {
        case .editImage:    openEditImageAlert()
        case .editName:     router.presentEditName()
        case .editPassword: router.presentEnterAuthCode()
        case .editEmail:    router.presentEditEmail()
        case .addWidget:    print("add widget")
        case .viewGroups:   print("view groupds")
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
            view?.setAvatarImage(image: avatarImage)
        }
        let currentIconName = UIApplication.shared.alternateIconName ?? "AppIconWhite"
        AppIconCell.initialSelectedIcon = currentIconName
        let index = AppIcon.indexForCase(withValue: currentIconName) ?? 0
        collectionView?.selectedAppIconIndexPath = IndexPath(item: index, section: 0)
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

// MARK: - Private funcs
extension AccountPresenter {
    private func imageFromBase64String(base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        guard let image = UIImage(data: imageData) else { return nil }
        return image
    }
}
