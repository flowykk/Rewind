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
    var email: String = "aleksa.khruleva@yandex.ru"
    var verificationCode: String = ""
    var password: String = ""
    var name: String = ""
    
    var groups: [Group] = []
    var currentGroup: Group? = nil
    
    var currentRandomMedia: Media?
}
