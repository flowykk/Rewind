//
//  PreviewObjectBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 20.03.2024.
//

import Foundation

final class PreviewObjectBuilder {
    static func build() -> PreviewObjectViewController {
        let viewController = PreviewObjectViewController()
        let router = PreviewObjectRouter(view: viewController)
        let presenter = PreviewObjectPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
