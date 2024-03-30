//
//  TagModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.03.2024.
//

import Foundation

struct Tag {
    var id: Int
    var text: String
    
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let text = json["text"] as? String else {
            return nil
        }
        self.id = id
        self.text = text
    }
}
