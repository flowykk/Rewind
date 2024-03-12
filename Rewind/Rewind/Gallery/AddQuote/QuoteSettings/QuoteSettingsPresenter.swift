//
//  QuoteSettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class QuoteSettingsPresenter {
    private weak var view: QuoteSettingsViewController?
    
    init(view: QuoteSettingsViewController?) {
        self.view = view
    }
    
    func continueButtonTapped() {
        print("save quote's settings")
        view?.dismiss(animated: true)
    }
}
