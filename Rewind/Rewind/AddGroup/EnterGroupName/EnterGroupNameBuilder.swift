//
//  EnterGroupNameBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation

final class EnterGroupNameBuilder {
    static func build() -> EnterGroupNameViewController {
        let viewController = EnterGroupNameViewController()
        let router = EnterGroupNameRouter(view: viewController)
        let presenter = EnterGroupNamePresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
