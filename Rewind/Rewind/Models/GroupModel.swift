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
    
    var image: UIImage?
    var owner: GroupMember?
    var members: [GroupMember]?
}