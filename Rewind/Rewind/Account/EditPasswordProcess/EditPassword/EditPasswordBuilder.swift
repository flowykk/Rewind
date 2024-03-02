//
//  EditPasswordBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation

final class EditPasswordBuilder {
    static func build() -> EditPasswordViewController {
        let viewController = EditPasswordViewController()
        let presenter = EditPasswordPresenter(view: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
