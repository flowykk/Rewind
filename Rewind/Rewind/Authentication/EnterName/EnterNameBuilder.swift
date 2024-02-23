//
//  EnterNameBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterNameBuilder {
    static func build() -> EnterNameViewController {
        let viewContoller = EnterNameViewController()
        let router = EnterNameRouter(view: viewContoller)
        let presenter = EnterNamePresenter(view: viewContoller, router: router)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
