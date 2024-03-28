//
//  AccountRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class AccountRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigateToAllGroups() {
        let vc = AllGroupsBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToWellcome() {
        let vc = WellcomeBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRewind() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentEditName() {
        let vc = EditNameBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        vc.delegate = view as? AccountViewController
        view?.present(vc, animated: true)
    }
    
    func presentEditEmail() {
        let vc = EditEmailBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        view?.present(vc, animated: true)
    }
    
    func presentEnterAuthCode() {
        let vc = EnterAuthCodeBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        view?.present(vc, animated: true)
    }
    
    func presentShareVC() {
        guard let appURL = URL(string: "https://www.rewindapp.ru") else { return }
        
        let vc = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        vc.excludedActivityTypes = [.addToReadingList, .assignToContact, .print,]
        
        view?.present(vc, animated: true) { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
