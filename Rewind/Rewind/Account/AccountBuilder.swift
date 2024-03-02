//
//  AccountBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import Foundation

final class AccountBuilder {
    static func build() -> AccountViewController {
        let viewController = AccountViewController()
        let router = AccountRouter(view: viewController)
        let presenter = AccountPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
