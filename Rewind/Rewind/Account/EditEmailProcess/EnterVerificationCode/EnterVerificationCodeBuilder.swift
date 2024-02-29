//
//  EnterVerificationCodeBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.02.2024.
//

import Foundation

final class EnterVerificationCodeBuilder {
    static func build() -> EnterVerificationCodeViewController {
        let viewController = EnterVerificationCodeViewController()
        let presenter = EnterVerificationCodePresenter(view: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
