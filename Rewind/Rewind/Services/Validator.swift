//
//  Validator.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import Foundation

final class Validator {
    static func isValidEmail(_ email: String?) -> Bool {
        guard let email = email, !email.isEmpty else {
            return false
        }
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }
    
    static func isValidName(_ name: String) -> Bool {
        return !name.isEmpty
    }
}
