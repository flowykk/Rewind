//
//  AllGroupsBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation

final class AllGroupsBuilder {
    static func build() -> AllGroupsViewController {
        let viewController = AllGroupsViewController()
        let router = AllGroupsRouter(view: viewController)
        let presenter = AllGroupsPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
