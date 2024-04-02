//
//  AddPhotoBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class AddPhotoBuilder {
    static func build() -> AddPhotoViewController {
        let viewController = AddPhotoViewController()
        let router = AddPhotoRouter(view: viewController)
        let presenter = AddPhotoPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
