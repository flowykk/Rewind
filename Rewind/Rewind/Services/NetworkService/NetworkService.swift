//
//  NetworkService.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation
import UIKit

final class NetworkService {
    private static let appUrl: String = "https://www.rewindapp.ru/api"
    
    
    // MARK: - Send Code To Register
    static func sendCodeToRegister(toEmail email: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/register/check-email/\(email)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Send Code To Log In
    static func checkEmailToLogin(email: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: "\(appUrl)/login/check-email/\(email)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Send Code
    static func sendCode(toEmail email: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/users/send-code/\(email)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Register User
    static func registerUser(withName name: String, email: String, password: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/register") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["userName": name, "email": email, "password": password]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Log In User
    static func loginUser(withEmail email: String, password: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/login") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["email": email, "password": password]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Delete User
    static func deleteUser(withId userId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/users/delete/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Update User Name
    static func updateUserName(userId: Int, newName: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-user/name/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["text" : newName]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Update User Email
    static func updateUserEmail(userId: Int, newEmail: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-user/email/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["email" : newEmail]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Update User Password
    static func updateUserPassword(userId: Int, newPassword: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-user/password/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["password" : newPassword]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Update User Image
    static func updateUserImage(userId: Int, bigImageB64String: String, miniImageB64String: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-user/image/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["object" : bigImageB64String, "tinyObject": miniImageB64String]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - Get User Info
    static func getUserInfo(userId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/users/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Greate Group
    static func createGroup(ownerId: Int, groupName: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/create") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["OwnerId": ownerId, "GroupName": groupName]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Get User Groups
    static func getUserGroups(userId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONArrayResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Get Group Basic Data
    static func getGroupBasicData(groupId: Int, userId: Int, membersQuantity: Int, mediaQuantity: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/info/\(groupId)/\(userId)?dataSize=\(membersQuantity)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Update Group Name
    static func updateGroupName(groupId: Int, newName: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-group/name/\(groupId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["text" : newName]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Update Group Image
    static func updateGroupImage(groupId: Int, bigImageB64String: String, miniImageB64String: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-group/image/\(groupId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["object" : bigImageB64String, "tinyobject" : miniImageB64String]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Get Group Members
    static func getGroupMembers(groupId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/users?groupId=\(groupId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONArrayResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Remove Member From Group
    static func removeMemberFromGroup(groupId: Int, memberId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/delete/\(groupId)/\(memberId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Delete Group
    static func deleteGroup(groupId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/delete/\(groupId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Get Initial Rewind Screen Data
    static func getInitialRewindScreenData(groupId: Int, userId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/initial/\(groupId)/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Get Random Media
    static func getRandomMedia(groupId: Int, userId: Int, includePhotos: Bool = true, includeQuotes: Bool = true, onlyFavorites: Bool = false, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/random/\(groupId)/\(userId)?images=\(includePhotos)&quotes=\(includeQuotes)&onlyfavorites=\(onlyFavorites)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Add Member To Group
    static func addMemberToGroup(groupId: Int, userId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/add/\(groupId)/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Get Media With Id Greater Than
    static func getMiniMediasWithIdGreaterThan(mediaId: Int, groupId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/media/\(groupId)?mediaId=\(mediaId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONArrayResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Get Media Info
    static func getMediaInfo(mediaId: Int, userId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/media/info/\(mediaId)/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Like Media
    static func likeMedia(userId: Int, mediaId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/media/like/\(userId)/\(mediaId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Unlike Media
    static func unlikeMedia(userId: Int, mediaId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/media/unlike/\(userId)/\(mediaId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Delete Media From Group
    static func deleteMediaFromGroup(groupId: Int, mediaId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/media/unload/\(mediaId)/\(groupId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Load Media To Group
    static func loadMediaToGroup(groupId: Int, userId: Int, isPhoto: Int, bigImageB64String: String, miniImageB64String: String, tagTexts: [String], completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/media/load/\(groupId)/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        print(url)
        print(groupId)
        print(userId)
        print(isPhoto)
        print(tagTexts)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["object" : bigImageB64String, "tinyobject" : miniImageB64String, "isPhoto": isPhoto, "tags": tagTexts]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Add Tag To Media
    static func addTagToMedia(mediaId: Int, tagTexts: [String], completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/tags/add/\(mediaId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["tags" : tagTexts]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processJSONArrayResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Delete Tag From Media
    static func deleteTagFromMedia(mediaId: Int, tagText: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/tags/delete/\(mediaId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["text" : tagText]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processStringResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Download Launch Image
    static func downloadLaunchImage() {
        guard let url = URL(string: "https://www.rewindapp.ru/welcomeImage.png"),
              let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.absoluteString else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let img = UIImage(data: data) ?? UIImage()
                let launchImageFileName = DataManager.shared.getLaunchImageFileName()
                let url = URL(string: "file://" + docDir + launchImageFileName)!
                try (img.pngData() ?? Data()).write(to: url)
            } catch {
                
            }
        }
        task.resume()
    }
}