//
//  GroupSettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation

final class GroupSettingsPresenter {
    private weak var view: GroupSettingsViewController?
    private var router: GroupSettingsRouter
    
    init(view: GroupSettingsViewController?, router: GroupSettingsRouter) {
        self.view = view
        self.router = router
    }
}
