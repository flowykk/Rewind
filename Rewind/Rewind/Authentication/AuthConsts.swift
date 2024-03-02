//
//  AuthConsts.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 21.02.2024.
//

import UIKit

struct AuthConsts {
    // MARK: - WellcomeViewController
    static let appNameTop: CGFloat = UIScreen.main.bounds.height / 3
    
    static let registerButtonBottom: CGFloat = 30
    
    static let loginButtonHeight: CGFloat = 25
    static let loginButtonBottom: CGFloat = UIScreen.main.bounds.height / 8
    
    // MARK: - EnterEmailViewController
    static let labelTop: CGFloat = UIScreen.main.bounds.height / 3
    static let continueButtonBottom: CGFloat = loginButtonBottom + loginButtonHeight + registerButtonBottom
}
