//
//  RewindPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 02.03.2024.
//

import Foundation

final class RewindPresenter {
    private weak var view: RewindViewController?
    private var router: RewindRouter
    
    init(view: RewindViewController?, router: RewindRouter) {
        self.view = view
        self.router = router
    }
    
    func goToAccount() {
        router.navigateToAccount()
    }
}
