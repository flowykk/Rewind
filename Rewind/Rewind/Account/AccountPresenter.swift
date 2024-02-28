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
    weak var generalTableView: GeneralTableView?
    
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
        case .editImage:
            view?.showEditImageAlert()
        case .editName:
            print("edit name")
        case .editPassword:
            print("edit password")
        case .editEmail:
            print("edit email")
        case .addWidget:
            print("add widget")
        case .viewGroups:
            print("view groupds")
        case .getHelp:
            print("get help")
        case .share:
            print("share")
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
