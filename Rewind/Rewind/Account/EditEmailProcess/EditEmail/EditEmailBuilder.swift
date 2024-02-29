//
//  EditEmailBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.02.2024.
//

import Foundation

final class EditEmailBuilder {
    static func build() -> EditEmailViewController {
        let viewController = EditEmailViewController()
        let router = EditEmailRouter(view: viewController)
        let presenter = EditEmailPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
