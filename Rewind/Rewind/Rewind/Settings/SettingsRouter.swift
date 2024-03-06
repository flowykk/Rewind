//
//  SettingsRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class SettingsRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func presentAddSearchTag() {
        let vc = AddSearchTagBuilder.build()
        if let settingsView = view as? SettingsViewController {
            vc.delegate = settingsView
            view?.present(vc, animated: true)
        }
    }
}
