//
//  EditPasswordPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation

final class EditPasswordPresenter {
    private weak var view: EditPasswordViewController?
    
    init(view: EditPasswordViewController) {
        self.view = view
    }
    
    func updatePassword(with password: String) {
        print("New password: \(password)")
        view?.dismiss(animated: true, completion: {
            self.view?.enterAuthCodeVC?.dismiss(animated: true)
        })
    }
}
