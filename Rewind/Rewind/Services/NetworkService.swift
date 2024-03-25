//
//  NetworkService.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import Foundation

struct NetworkResponse {
    var success: Bool
    var statusCode: Int?
    var message: String?
    var json: [String : Any]?
    var jsonArray: [[String : Any]]?
}

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
            let parameters: [String : Any] = ["name" : newName]
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
    static func updateUserImage(userId: Int, newImage: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-user/image/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["media" : newImage]
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
            let networkResponse = self.processJSONAarrayResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    // MARK: - Delete Group
    static func deleteGroup(withId groupId: Int, completion: @escaping (NetworkResponse) -> Void) {
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
    
    static func getGroupBasicData(groupId: Int, membersQuantity: Int, mediaQuantity: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/groups/\(groupId)/\(membersQuantity)") else {
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
}

// MARK: - Private funcs
extension NetworkService {
    static private func processStringResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
        if let error = error {
            return NetworkResponse(success: false, message: error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkResponse(success: false, message: "Unexpected response format")
        }
        
        let success = httpResponse.statusCode == 200
        let statusCode = httpResponse.statusCode
        var message: String? = nil
        
        if let data = data, let encodingMessage = String(data: data, encoding: .utf8) {
            message = encodingMessage
        }
        
        return NetworkResponse(success: success, statusCode: statusCode, message: message)
    }
    
    static private func processJSONResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
        if let error = error {
            return NetworkResponse(success: false, message: error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkResponse(success: false, message: "Unexpected response format")
        }
        
        let success = httpResponse.statusCode == 200
        let statusCode = httpResponse.statusCode
        var json: [String: Any]? = nil
        
        if let data = data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDictionary = jsonObject as? [String: Any] {
                    json = jsonDictionary
                }
            } catch {
                return NetworkResponse(success: false, statusCode: statusCode, message: "Error decoding JSON")
            }
        }
        
        return NetworkResponse(success: success, statusCode: statusCode, json: json)
    }
    
    static private func processJSONAarrayResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
        if let error = error {
            return NetworkResponse(success: false, message: error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkResponse(success: false, message: "Unexpected response format")
        }
        
        let success = httpResponse.statusCode == 200
        let statusCode = httpResponse.statusCode
        var jsonArray: [[String: Any]]? = nil
        
        if let data = data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDictionary = jsonObject as? [[String: Any]] {
                    jsonArray = jsonDictionary
                }
            } catch {
                return NetworkResponse(success: false, statusCode: statusCode, message: "Error decoding JSON")
            }
        }
        
        return NetworkResponse(success: success, statusCode: statusCode, jsonArray: jsonArray)
    }
}
