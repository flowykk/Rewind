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
    
    func newImageSelected(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            updateUserImage(withImageData: imageData)
        }
    }
    
    func copyEmailToPasteboard() {
        UIPasteboard.general.string = "sent@rewindapp.ru"
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "UserId")
        UserDefaults.standard.removeObject(forKey: "UserName")
        UserDefaults.standard.removeObject(forKey: "UserEmail")
        UserDefaults.standard.removeObject(forKey: "UserRegDate")
        router.navigateToWellcome()
    }
    
    func deleteAccount() {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.deleteUser(withId: userId) { response in
            DispatchQueue.main.async {
                if response.success {
                    UserDefaults.standard.removeObject(forKey: "UserId")
                    UserDefaults.standard.removeObject(forKey: "UserName")
                    UserDefaults.standard.removeObject(forKey: "UserEmail")
                    UserDefaults.standard.removeObject(forKey: "UserRegDate")
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
        case .editPassword:
            guard let userEmail = UserDefaults.standard.string(forKey: "UserEmail") else { return }
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
        if let userName = UserDefaults.standard.string(forKey: "UserName") {
            view?.setUserName(to: userName)
        }
        
        if let regDate = UserDefaults.standard.string(forKey: "UserRegDate") {
            if let days = getDaysWithRewind(regDate: regDate) {
                view?.setDaysWithRewind(to: days)
            }
        }
        
        let currentIconName = UIApplication.shared.alternateIconName ?? "AppIconWhite"
        AppIconCell.initialSelectedIcon = currentIconName
        
        let index = AppIcon.indexForCase(withValue: currentIconName) ?? 0
        collectionView?.selectedAppIconIndexPath = IndexPath(item: index, section: 0)
    }
    
    func didUpdateImage(to imageData: Data) {
        if let image = UIImage(data: imageData) {
            view?.setUserImage(to: image)
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
    
    private func updateUserImage(withImageData newImageData: Data) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        let imageBase64String = newImageData.base64EncodedString()
        NetworkService.updateUserImage(userId: userId, newImage: imageBase64String) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleUpdateUserImageResponse(response, imageData: newImageData)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension AccountPresenter {
    private func handleUpdateUserImageResponse(_ response: NetworkResponse, imageData: Data) {
        if response.success {
            DispatchQueue.main.async {
                self.didUpdateImage(to: imageData)
            }
        }
    }
}

extension AccountPresenter {
    private func getDaysWithRewind(regDate: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: regDate) else {
            return nil
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let givenDate = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: givenDate, to: today)
        if let days = components.day {
            return days + 1
        } else {
            return nil
        }
    }
}
