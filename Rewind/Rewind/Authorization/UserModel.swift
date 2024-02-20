//
//  User.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

struct User {
    enum Process {
        case none
        case registration
        case authorization
    }
    
    var proccess: Process = .none
    var email: String = ""
    var verificationCode: String = ""
    var password: String = ""
    var name: String = ""
}
