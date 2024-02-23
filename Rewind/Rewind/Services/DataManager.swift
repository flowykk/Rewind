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
    
    // MARK: - SET methods
    func setUserProcess(_ process: User.Process) {
        user.proccess = process
    }
    
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
    
    func setAvatarBase64String(_ avatarBase64String: String) {
        user.avatarBase64String = avatarBase64String
    }
    
    // MARK: - GET methods
    func getUserProcess() -> User.Process {
        return user.proccess
    }
    
    func getUserVerificationCode() -> String {
        return user.verificationCode
    }
    
    func getAvatarBase64String() -> String {
        return user.avatarBase64String
    }
    
    func getUser() -> User {
        return user
    }
}