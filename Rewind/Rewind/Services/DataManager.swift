//
//  DataManager.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

final class DataManager {
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
    
    func setUserId(_ id: Int) {
        user.id = id
    }
    
    func setUserImageBase64String(_ imageBase64String: String) {
        user.imageBase64String = imageBase64String
    }
    
    // MARK: - GET methods
    func getUser() -> User {
        return user
    }
    
    func getUserEmail() -> String {
        return user.email
    }
    
    func getUserProcess() -> User.Process {
        return user.proccess
    }
    
    func getUserVerificationCode() -> String {
        return user.verificationCode
    }
    
    func getAvatarBase64String() -> String {
        return user.imageBase64String
    }
    
    func getUserId() -> Int {
        return user.id
    }
    
    func getUserName() -> String {
        return user.name
    }
}
