//
//  DetailsBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

final class DetailsBuilder {
    static func build() -> DetailsViewController {
        let viewController = DetailsViewController()
        let router = DetailsRouter(view: viewController)
        let presenter = DetailsPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
