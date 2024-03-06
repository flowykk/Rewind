//
//  AddTagPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

final class AddTagPresenter {
    private weak var view: AddTagViewController?
    
    init(view: AddTagViewController?) {
        self.view = view
    }
    
    func addTag(withTitle title: String) {
        view?.addTagHandler?(title)
        view?.dismiss(animated: true)
    }
}
