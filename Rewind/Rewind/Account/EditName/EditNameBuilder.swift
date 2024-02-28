//
//  EditNameBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation

final class EditNameBuilder {
    static func build() -> EditNameViewController {
        let viewController = EditNameViewController()
        let presenter = EditNamePresenter(view: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
