//
//  GroupSettingsBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation

final class GroupSettingsBuilder {
    static func build() -> GroupSettingsViewController {
        let viewController = GroupSettingsViewController()
        let router = GroupSettingsRouter(view: viewController)
        let presenter = GroupSettingsPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
