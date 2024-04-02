//
//  DataManager.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation
import UIKit

final class DataManager {
    static let shared = DataManager()
    private var user = User()
    private var filter = Filter()
    private var launchImage: UIImage = UIImage()
    private let launchImageFileName = "launchImage.png"
    
    func setCurrentRandomMedia(to newRandomMedia: Media?) {
        user.currentRandomMedia = newRandomMedia
    }
    
    func getCurrentRandomMedia() -> Media? {
        return user.currentRandomMedia
    }
    
    func getLaunchImageFileName() -> String {
        return launchImageFileName
    }
    
    func setLaunchImage(to newImage: UIImage) {
        launchImage = newImage
    }
    
    func getLaunchImage() -> UIImage {
        return launchImage
    }
    
    func getFilter() -> Filter {
        return filter
    }
    
    func setNewTypeValue(forType type: TypesTableView.TypeRow, newValue: Bool) {
        switch type {
        case .Photos:
            filter.includePhotos = newValue
        case .Quotes:
            filter.includeQuotes = newValue
        }
    }
    
    func setNewPropertyValue(forProperty property: PropertiesTableView.PropertyRow, newValue: Bool) {
        switch property {
        case .favorites:
            filter.onlyFavorites = newValue
        }
    }
    
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
        UserDefaults.standard.set(group.id, forKey: "CurrentGroupId")
    }
    
    func resetCurrentGroup() {
        user.currentGroup = nil
    }
    
    func setCurrentGroupName(_ name: String) {
        user.currentGroup?.name = name
    }
    
    func setCurrentGroupBigImage(_ imageData: Data) {
        user.currentGroup?.bigImage = UIImage(data: imageData)
    }
    
    func setCurrentGroupMiniImage(_ imageData: Data) {
        user.currentGroup?.miniImage = UIImage(data: imageData)
    }
    
    func setUserGroups(_ groups: [Group]) {
        user.groups = groups
    }
    
    func addGroupToGroups(_ group: Group) {
        user.groups.append(group)
    }
    
    func updateGroupWithName(_ groupName: String, forGroupWithId groupId: Int) {
        for index in user.groups.indices {
            if user.groups[index].id == groupId {
                user.groups[index].name = groupName
                return
            }
        }
    }
    
    func updateGroupWithImage(bigImageData: Data, miniImageData: Data, forGroupWithId groupId: Int) {
        for index in user.groups.indices {
            if user.groups[index].id == groupId {
                user.groups[index].bigImage = UIImage(data: bigImageData)
                user.groups[index].miniImage = UIImage(data: miniImageData)
                return
            }
        }
    }
    
    func removeGroupFromGroups(groupId: Int) {
        for index in user.groups.indices {
            if user.groups[index].id == groupId {
                user.groups.remove(at: index)
                return
            }
        }
    }
    
    func setCurrentGroupToRandomUserGroup() {
        user.currentGroup = user.groups.randomElement()
    }
    
    func setCurrentGroupGallerySize(_ newGallerySize: Int) {
        if var currentGroup = user.currentGroup {
            currentGroup.gallerySize = newGallerySize
            user.currentGroup = currentGroup
        }
    }
    
    func decrementCurrentGroupGallerySizer() {
        if var currentGroup = user.currentGroup,
           let gallerySize = currentGroup.gallerySize
        {
            let newGallerySize = max(0, gallerySize - 1)
            currentGroup.gallerySize = newGallerySize
            user.currentGroup = currentGroup
        }
    }
    
    func incrementCurrentGroupGallerySizer() {
        if var currentGroup = user.currentGroup,
           let gallerySize = currentGroup.gallerySize
        {
            let newGallerySize = max(0, gallerySize + 1)
            currentGroup.gallerySize = newGallerySize
            user.currentGroup = currentGroup
        }
    }
    
    func getUserGroups() -> [Group] {
        return user.groups
    }
    
    func getCurrectGroupId() -> Int? {
        return user.currentGroup?.id
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
