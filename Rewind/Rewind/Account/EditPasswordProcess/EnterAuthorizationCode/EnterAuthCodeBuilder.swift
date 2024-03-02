//
//  EnterAuthCodeBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation

final class EnterAuthCodeBuilder {
    static func build() -> EnterAuthCodeViewController {
        let viewController = EnterAuthCodeViewController()
        let router = EnterAuthCodeRouter(view: viewController)
        let presenter = EnterAuthCodePresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
