//
//  DataManager.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private var user = User()
    
    func setUserEmail(_ email: String) {
        user.email = email
    }
    
    func setUserVerificationCode(_ verificationCode: String) {
        user.verificationCode = verificationCode
    }
    
    func setUserPassword(_ password: String) {
        user.password = password
    }
    
    func setUserName(_ name: String) {
        user.name = name
    }
    
    func getUserVerificationCode() -> String {
        return user.verificationCode
    }
    
    func getUser() -> User {
        return user
    }
}
