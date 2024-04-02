//
//  GroupModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import UIKit

struct Group {
    var id: Int
    var name: String
    var ownerId: Int
    
    var bigImage: UIImage?
    var miniImage: UIImage?
    
    var owner: GroupMember?
    var members: [GroupMember]?
    
    var gallerySize: Int?
    var medias: [Media]?
    
    init(
        id: Int,
        name: String,
        ownerId: Int,
        bigImage: UIImage? = nil,
        miniImage: UIImage? = nil,
        owner: GroupMember? = nil,
        members: [GroupMember]? = nil,
        gallerySize: Int? = nil,
        medias: [Media]? = nil
    ) {
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.bigImage = bigImage
        self.miniImage = miniImage
        self.owner = owner
        self.members = members
        self.gallerySize = gallerySize
        self.medias = medias
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String,
              let ownerId = json["ownerId"] as? Int
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.ownerId = ownerId
        
        self.bigImage = parseImage(forKey: "image", in: json)
        self.miniImage = parseImage(forKey: "tinyImage", in: json)
        
        if let ownerJSON = json["owner"] as? [String: Any] {
            self.owner = GroupMember(json: ownerJSON, role: .owner)
        }
        
        if let membersJSON = json["members"] as? [[String: Any]] {
            var membersList: [GroupMember] = []
            
            for memberJSON in membersJSON {
                if let member = GroupMember(json: memberJSON, role: .member) {
                    membersList.append(member)
                }
            }
            
            self.members = membersList
        }
        
        if let gallerySize = json["gallerySize"] as? Int {
            self.gallerySize = gallerySize
        }
        
        if let mediasJSON = json["medias"] as? [[String: Any]] {
            var mediasList: [Media] = []
            
            for mediaJSON in mediasJSON {
                if let media = Media(json: mediaJSON) {
                    mediasList.append(media)
                }
            }
            
            self.medias = mediasList
        }
    }
    
    private func parseImage(forKey key: String, in json: [String: Any]) -> UIImage? {
        guard let imageB64String = json[key] as? String else { return nil }
        return UIImage(base64String: imageB64String)
    }
}
