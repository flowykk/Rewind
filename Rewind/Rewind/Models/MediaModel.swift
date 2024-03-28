//
//  MediaModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import UIKit

struct Media {
    var id: Int
    var miniImage: UIImage?
    var bigImage: UIImage?
    var dateAdded: String?
    var author: Author?
    var liked: Bool?
    
    init?(json: [String : Any]?) {
        guard let json = json,
              let id = json["id"] as? Int
        else {
            return nil
        }
        
        self.id = id
        self.bigImage = parseImage(forKey: "object", in: json)
        self.miniImage = parseImage(forKey: "tinyObject", in: json)
        if let dateString = json["date"] as? String {
            self.dateAdded = convertDateString(dateString)
        }
        self.author = Author(json: json["author"] as? [String: Any])
        self.liked = json["liked"] as? Bool
    }
    
    private func parseImage(forKey key: String, in json: [String: Any]) -> UIImage? {
        guard let imageB64String = json[key] as? String else { return nil }
        return UIImage(base64String: imageB64String)
    }
    
    private func convertDateString(_ inputDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        guard let date = dateFormatter.date(from: inputDateString) else {
            return nil
        }

        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
