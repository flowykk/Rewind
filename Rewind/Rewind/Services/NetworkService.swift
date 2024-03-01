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
}

final class NetworkService {
    private static let appUrl: String = "https://www.rewindapp.ru/api"
    
    
    // MARK: - sendCodeToRegister
    static func sendCodeToRegister(toEmail email: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/register/check-email/\(email)") else {
            completion(NetworkResponse(success: false))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - sendCode
    static func sendCode(toEmail email: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/users/send-code/\(email)") else {
            completion(NetworkResponse(success: false))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - registerUser
    static func registerUser(user: User, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/register") else {
            completion(NetworkResponse(success: false))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["userName": user.name, "email": user.email, "password": user.password]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - sendCodeToLogin
    static func sendCodeToLogin(_ email: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: "\(appUrl)/login/check-email/\(email)") else {
            completion(NetworkResponse(success: false))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processResponse(data: data, response: response, error: error)
                completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - loginUser
    static func loginUser(withEmail email: String, password: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/login") else {
            completion(NetworkResponse(success: false))
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
            let networkResponse = self.processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - deleteUser
    static func deleteUser(withId userId: Int, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/users/delete/\(userId)") else {
            completion(NetworkResponse(success: false))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - updateUserName
    static func updateUserName(userId: Int, newName: String, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = URL(string: appUrl + "/change-user/name/\(userId)") else {
            completion(NetworkResponse(success: false, message: "Wrong URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters: [String : Any] = ["username" : newName]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(NetworkResponse(success: false, message: error.localizedDescription))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let networkResponse = self.processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - updateUserEmail
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
            let networkResponse = self.processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
    
    
    // MARK: - updateUserPassword
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
            let networkResponse = self.processResponse(data: data, response: response, error: error)
            completion(networkResponse)
        }
        task.resume()
    }
}

// MARK: - Private funcs
extension NetworkService {
    static private func processResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
        if let error = error {
            return NetworkResponse(success: false, message: error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkResponse(success: false)
        }
        
        let success = httpResponse.statusCode == 200
        let statusCode = httpResponse.statusCode
        var message: String? = nil
        
        if let data = data, let encodingMessage = String(data: data, encoding: .utf8) {
            message = encodingMessage
        }
        
        return NetworkResponse(success: success, statusCode: statusCode, message: message)
    }
}
