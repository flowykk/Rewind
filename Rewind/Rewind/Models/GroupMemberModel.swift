//
//  GroupMemberModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import UIKit

enum MemberRole {
    case user
    case owner
    case member
}

struct GroupMember {
    var id: Int
    var name: String
    var role: MemberRole
    
    var miniImage: UIImage?
    
    init(id: Int, name: String, role: MemberRole, miniImage: UIImage? = nil) {
        self.id = id
        self.name = name
        self.role = role
        self.miniImage = miniImage
    }
    
    init?(json: [String: Any], role: MemberRole) {
        guard let id = json["id"] as? Int, let name = json["userName"] as? String else {
            return nil
        }
        
        if let base64String = json["tinyProfileImage"] as? String {
            let miniImage = UIImage(base64String: base64String)
            self.miniImage = miniImage
        }
        
        self.id = id
        self.name = name
        self.role = role
    }
}
