//
//  LaunchRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import UIKit

final class LaunchRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToWellcome() {
        let vc = WellcomeBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRewind() {
        let vc = RewindBuilder.build()
        let randomMedia = DataManager.shared.getCurrentRandomMedia()
        vc.fromLaunch = true
        vc.randomMediaId = randomMedia?.id
        vc.configureUIForCurrentGroup()
        vc.configureUIForRandomMedia(randomMedia)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
