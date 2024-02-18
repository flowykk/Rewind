//
//  EnterEmailBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterEmailBuilder {
    static func build() -> EnterEmailViewController {
        let viewContoller = EnterEmailViewController()
        let router = EnterEmailRouter(view: viewContoller)
        let presenter = EnterEmailPresenter(view: viewContoller, router: router)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
