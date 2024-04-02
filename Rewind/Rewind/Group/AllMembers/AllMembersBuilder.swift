//
//  AllMembersBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import Foundation

final class AllMembersBuilder {
    static func build() -> AllMembersViewController {
        let viewController = AllMembersViewController()
        let router = AllMembersRouter(view: viewController)
        let presenter = AllMembersPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
