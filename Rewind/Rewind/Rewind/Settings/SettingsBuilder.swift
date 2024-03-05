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
        let presenter = SettingsPresenter(view: viewContoller)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
