//
//  ResponseProcessor.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import Foundation

extension NetworkService {
    // MARK: - Process String Response
    static internal func processStringResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
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
    
    // MARK: - Process JSON Response
    static internal func processJSONResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
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
    
    // MARK: - Process JSON Array Response
    static internal func processJSONArrayResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
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
