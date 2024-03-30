//
//  LaunchBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import Foundation

final class LaunchBuilder {
    static func build() -> LaunchViewController {
        let viewController = LaunchViewController()
        let router = LaunchRouter(view: viewController)
        let presenter = LaunchPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
