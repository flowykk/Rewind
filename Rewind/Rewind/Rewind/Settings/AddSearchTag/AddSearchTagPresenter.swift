//
//  AddSearchTagPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

final class AddSearchTagPresenter {
    private weak var view: AddSearchTagViewController?
    
    init(view: AddSearchTagViewController?) {
        self.view = view
    }
    
    func addTag(withTitle title: String) {
        view?.delegate?.presenter?.addTag(title)
        view?.dismiss(animated: true)
    }
}
