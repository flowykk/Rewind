//
//  AuthorModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.03.2024.
//

import UIKit

struct Author {
    var id: Int
    var name: String
    var miniImage: UIImage?
    
    init?(json: [String : Any]?) {
        guard let json = json,
              let id = json["id"] as? Int,
              let name = json["userName"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.miniImage = parseImage(forKey: "tinyProfileImage", in: json)
    }
    
    private func parseImage(forKey key: String, in json: [String: Any]) -> UIImage? {
        guard let imageB64String = json[key] as? String else { return nil }
        return UIImage(base64String: imageB64String)
    }
}
