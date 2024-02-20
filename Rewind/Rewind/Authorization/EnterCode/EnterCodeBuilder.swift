//
//  EnterCodeBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class EnterCodeBuilder {
    static func build() -> EnterCodeViewController {
        let viewContoller = EnterCodeViewController()
        let router = EnterCodeRouter(view: viewContoller)
        let presenter = EnterCodePresenter(view: viewContoller, router: router)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
