//
//  MediaModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import UIKit

struct Media {
    var id: Int
    var miniImage: UIImage
    
    init?(json: [String : Any]) {
        guard let id = json["id"] as? Int, let miniImageB64String = json["tinyObject"] as? String else { return nil }
        
        guard let miniImage = UIImage(base64String: miniImageB64String) else { return nil }
        
        self.id = id
        self.miniImage = miniImage
    }
}
