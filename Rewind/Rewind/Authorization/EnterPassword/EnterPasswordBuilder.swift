//
//  EnterPasswordBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterPasswordBuilder {
    static func build() -> EnterPasswordViewController {
        let viewContoller = EnterPasswordViewController()
        let router = EnterPasswordRouter(view: viewContoller)
        let presenter = EnterPasswordPresenter(view: viewContoller, router: router)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
