//
//  GroupBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation

final class GroupBuilder {
    static func build() -> GroupViewController {
        let viewController = GroupViewController()
        let router = GroupRouter(view: viewController)
        let presenter = GroupPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
