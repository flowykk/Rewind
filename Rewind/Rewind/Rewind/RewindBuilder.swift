//
//  RewindBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 02.03.2024.
//

import Foundation

final class RewindBuilder {
    static func build() -> RewindViewController {
        let viewController = RewindViewController()
        let router = RewindRouter(view: viewController)
        let presenter = RewindPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
