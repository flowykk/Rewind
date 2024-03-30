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
    var shortDateAdded: String?
    var author: Author?
    var liked: Bool?
    var tags: [Tag]?
    
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
            let formattedDates = getFormattedDate(dateString)
            self.dateAdded = formattedDates.dateAdded
            self.shortDateAdded = formattedDates.shortDateAdded
        }
        self.author = Author(json: json["author"] as? [String: Any])
        self.liked = json["liked"] as? Bool
        if let tagsJsonArray = json["tags"] as? [[String : Any]] {
            self.tags = parseTags(json: tagsJsonArray)
        }
    }
    
    private func parseImage(forKey key: String, in json: [String: Any]) -> UIImage? {
        guard let imageB64String = json[key] as? String else { return nil }
        return UIImage(base64String: imageB64String)
    }
    
    private func getFormattedDate(_ inputDateString: String) -> (dateAdded: String?, shortDateAdded: String?) {
        let dateString = inputDateString.prefix(10)
        let splitedDate = dateString.split(separator: "-").reversed()
        
        if splitedDate.count >= 3 {
            let formattedDate = splitedDate.joined(separator: ".")
            let formattedShortDate = String(formattedDate.prefix(5))
            return (formattedDate, formattedShortDate)
        }
        
        return (nil, nil)
    }
    
    private func parseTags(json jsonArray: [[String: Any]]) -> [Tag] {
        var tags: [Tag] = []
        for json in jsonArray {
            if let tag = Tag(json: json) {
                tags.append(tag)
            }
        }
        return tags
    }
}
