//
//  SettingsBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 05.03.2024.
//

import Foundation

final class SettingsBuilder {
    static func build() -> SettingsViewController {
        let viewContoller = SettingsViewController()
        let router = SettingsRouter(view: viewContoller)
        let presenter = SettingsPresenter(view: viewContoller, router: router)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
