//
//  WellcomeBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class WellcomeBuilder {
    static func build() -> WellcomeViewController {
        let viewController = WellcomeViewController()
        let router = WellcomeRouter(view: viewController)
        let presenter = WellcomePresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
