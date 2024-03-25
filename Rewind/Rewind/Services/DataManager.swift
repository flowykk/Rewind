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
    
    func setCurrentGroup(_ group: Group) {
        user.currentGroup = group
    }
    
    func setCurrentGroupName(_ name: String) {
        user.currentGroup?.name = name
    }
    
    func setUserGroups(_ groups: [Group]) {
        user.groups = groups
    }
    
    func updateGroupWithName(_ groupName: String, forGroupWithId groupId: Int) {
        for index in user.groups.indices {
            if user.groups[index].id == groupId {
                user.groups[index].name = groupName
                return
            }
        }
    }
    
    // MARK: - GET methods
    func getUserGroups() -> [Group] {
        return user.groups
    }
    
    func getUser() -> User {
        return user
    }
    
    func getUserEmail() -> String {
        return user.email
    }
    
    func getUserPassword() -> String {
        return user.password
    }
    
    func getUserProcess() -> User.Process {
        return user.proccess
    }
    
    func getUserVerificationCode() -> String {
        return user.verificationCode
    }
    
    func getCurrentGroup() -> Group? {
        return user.currentGroup
    }
}
