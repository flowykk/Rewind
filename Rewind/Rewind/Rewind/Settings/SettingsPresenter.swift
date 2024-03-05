//
//  SettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 05.03.2024.
//

import Foundation

final class SettingsPresenter {
    private weak var view: SettingsViewController?
    
    init(view: SettingsViewController?) {
        self.view = view
    }
}
