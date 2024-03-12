//
//  AddQuoteBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class AddQuoteBuilder {
    static func build() -> AddQuoteViewController {
        let viewController = AddQuoteViewController()
        let router = AddQuoteRouter(view: viewController)
        let presenter = AddQuotePresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
