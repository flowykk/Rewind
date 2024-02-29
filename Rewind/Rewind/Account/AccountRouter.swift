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
    
    func navigateToRewind() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentEditName() {
        let vc = EditNameBuilder.build()
        view?.present(vc, animated: true)
    }
    
    func presentEnterAuthCode() {
        let vc = EnterAuthCodeBuilder.build()
        view?.present(vc, animated: true)
    }
    
    func presentEditEmail() {
        let vc = EditEmailBuilder.build()
        view?.present(vc, animated: true)
    }
    
    func presentShareVC() {
        guard let appURL = URL(string: "https://www.rewindapp.ru") else { return }
        
        let vc = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        vc.excludedActivityTypes = [.addToReadingList, .assignToContact, .print,]
        
        view?.present(vc, animated: true)
    }
}
