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
        let presenter = PreviewObjectPresenter(viewController: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
