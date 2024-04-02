//
//  NetworkResponseModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import Foundation

struct NetworkResponse {
    var success: Bool
    var statusCode: Int?
    var message: String?
    var json: [String : Any]?
    var jsonArray: [[String : Any]]?
}
