//
//  EditNamePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation
import UIKit

final class EditNamePresenter {
    private weak var view: EditNameViewController?
    
    init(view: EditNameViewController) {
        self.view = view
    }
    
    func updateName(with name: String) {
        view?.dismiss(animated: true)
    }
}
