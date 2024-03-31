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
        let password = password
        if password.count < 6 {
            return false
        }
        let passwordRegex = #"^[a-zA-Z0-9]+$"#
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    static func isValidUserName(_ name: String) -> Bool {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !name.isEmpty
    }
    
    static func isValidGroupName(_ name: String) -> Bool {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !name.isEmpty
    }
    
    static func isValidQuote(_ quote: String) -> Bool {
        let quote = quote.trimmingCharacters(in: .whitespacesAndNewlines)
        return !quote.isEmpty
    }
    
    static func isValidTag(_ tag: String) -> Bool {
        let tag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        if tag.count <= 0 || tag.count > 10 {
            return false
        }
        return true
    }
}
