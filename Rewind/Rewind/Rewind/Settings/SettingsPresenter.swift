//
//  SettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 05.03.2024.
//

import Foundation

final class SettingsPresenter {
    private weak var view: SettingsViewController?
    weak var typesTable: TypesTableView?
    weak var propertiesTable: PropertiesTableView?
    private var router: SettingsRouter
    
    init(view: SettingsViewController?, router: SettingsRouter) {
        self.view = view
        self.router = router
    }
    
    func configureUIForFilter() {
        let filter = DataManager.shared.getFilter()
        typesTable?.configureUIForSavedFilter(filter)
        propertiesTable?.configureUIForSavedFilter(filter)
    }
    
    func continueButtonTapped() {
        view?.dismiss(animated: true)
    }
}
