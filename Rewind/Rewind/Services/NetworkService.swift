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
    static func sendVerificationCode(
        toEmail email: String,
        completion: @escaping (NetworkResponse) -> Void
    ) {
        guard let url = URL(string: "https://www.rewindapp.ru/api/register/check-email/\(email)") else {
            let response = NetworkResponse(success: false)
            completion(response)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let response = NetworkResponse(success: false, message: error.localizedDescription)
                completion(response)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let response = NetworkResponse(success: false)
                completion(response)
                return
            }
            if httpResponse.statusCode == 200 {
                let response = NetworkResponse(success: true, message: String(data: data ?? Data(), encoding: .utf8))
                completion(response)
            } else {
                let response = NetworkResponse(success: false, statusCode: httpResponse.statusCode)
                completion(response)
            }
        }
        task.resume()
    }
    
    static func registerUser(
        user: User,
        completion: @escaping (NetworkResponse) -> Void
    ) {
        guard let url = URL(string: "https://www.rewindapp.ru/api/register") else {
            let response = NetworkResponse(success: false)
            completion(response)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String : Any] = [
            "userName": user.name,
            "email": user.email,
            "password": user.password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // TODO: catch error
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let response = NetworkResponse(success: false, message: error.localizedDescription)
                completion(response)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let response = NetworkResponse(success: false)
                completion(response)
                return
            }
            if httpResponse.statusCode == 200 {
                let response = NetworkResponse(success: true, message: String(data: data ?? Data(), encoding: .utf8))
                completion(response)
            } else {
                print(httpResponse.statusCode)
                let response = NetworkResponse(success: false, statusCode: httpResponse.statusCode)
                completion(response)
            }
        }
        task.resume()
    }
    
    static func checkEmailExistence(
        _ email: String,
        completion: @escaping (NetworkResponse) -> Void
    ) {
        guard let url = URL(string: "https://www.rewindapp.ru/api/login/check-email/\(email)") else {
            let response = NetworkResponse(success: false)
            completion(response)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let response = NetworkResponse(success: false, message: error.localizedDescription)
                completion(response)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let response = NetworkResponse(success: false)
                completion(response)
                return
            }
            if httpResponse.statusCode == 200 {
                let response = NetworkResponse(success: true, message: String(data: data ?? Data(), encoding: .utf8))
                completion(response)
            } else {
                let response = NetworkResponse(success: false, statusCode: httpResponse.statusCode)
                completion(response)
            }
        }
        task.resume()
    }
    
    static func authorizeUser(
        user: User,
        completion: @escaping (NetworkResponse) -> Void
    ) {
        guard let url = URL(string: "https://www.rewindapp.ru/api/login") else {
            let response = NetworkResponse(success: false)
            completion(response)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String : Any] = [
            "email": user.email,
            "password": user.password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // TODO: catch error
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let response = NetworkResponse(success: false, message: error.localizedDescription)
                completion(response)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let response = NetworkResponse(success: false)
                completion(response)
                return
            }
            if httpResponse.statusCode == 200 {
                let response = NetworkResponse(success: true, message: String(data: data ?? Data(), encoding: .utf8))
                completion(response)
            } else {
                print(httpResponse.statusCode)
                let response = NetworkResponse(success: false, statusCode: httpResponse.statusCode)
                completion(response)
            }
        }
        task.resume()
    }
    
    static func getAvatar(
        completion: @escaping (NetworkResponse) -> Void
    ) {
        guard let url = URL(string: "https://www.rewindapp.ru/qwsaqwsa/select02.json") else {
            let response = NetworkResponse(success: false)
            completion(response)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let response = NetworkResponse(success: false, message: error.localizedDescription)
                completion(response)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let response = NetworkResponse(success: false)
                completion(response)
                return
            }
            if httpResponse.statusCode == 200 {
                do {
                    guard let data = data else {
                        let response = NetworkResponse(success: false)
                        completion(response)
                        return
                    }
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let avatarString = json?["avatar"] as? String {
                        let response = NetworkResponse(success: true, message: avatarString)
                        completion(response)
                    }
                } catch {
                    
                }
            } else {
                print(httpResponse.statusCode)
                let response = NetworkResponse(success: false, statusCode: httpResponse.statusCode)
                completion(response)
            }
        }
        task.resume()
    }
}
