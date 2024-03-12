//
//  QuoteSettingsBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class QuoteSettingsBuilder {
    static func build() -> QuoteSettingsViewController {
        let viewController = QuoteSettingsViewController()
        let presenter = QuoteSettingsPresenter(view: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
