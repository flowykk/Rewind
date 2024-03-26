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
    
    func navigateAllMembers() {
        let vc = AllMembersBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToGallery() {
        let vc = GalleryBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
