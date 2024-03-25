//
//  GroupPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation

final class GroupPresenter {
    private weak var view: GroupViewController?
    private var router: GroupRouter
    
    init(view: GroupViewController?, router: GroupRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToRewind()
    }
    
    func groupSettingsButtonTapped() {
        router.navigateToGroupSettings()
    }
    
    func groupMediaButtonTapped() {
        router.navigateToGallery()
    }
    
    func getGroupInfo() {
        
    }
    
}
