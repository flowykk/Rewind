//
//  EditGroupNameBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation

final class EditGroupNameBuilder {
    static func build() -> EditGroupNameViewController {
        let viewController = EditGroupNameViewController()
        let presenter = EditGroupNamePresenter(view: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
