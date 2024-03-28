////
////  JoinResponseHandler.swift
////  Rewind
////
////  Created by Aleksa Khruleva on 28.03.2024.
////
//
//import UIKit
//
//final class JoinResponseHandler {
//    static func handleJoinResponse(_ response: NetworkResponse) {
//        if response.success, let json = response.json {
//            if let groupId = json["id"] as? Int,
//               let groupName = json["name"] as? String,
//               let ownerJson = json["owner"] as? [String : Any],
//               let membersJsonArray = json["firstMembers"] as? [[String : Any]],
//               let mediaJsonArray = json["firstMedia"] as? [[String : Any]]
//            {
//                var groupImage: UIImage? = nil
//                if let base64String = json["image"] as? String {
//                    groupImage = UIImage(base64String: base64String)
//                }
//                
//                let userId = UserDefaults.standard.integer(forKey: "UserId")
//                let userName = UserDefaults.standard.string(forKey: "UserName") ?? "Anonymous"
//                let userImage = UserDefaults.standard.image(forKey: "UserImage")
//                
//                let user = GroupMember(id: userId, name: userName, role: .user, miniImage: userImage)
//                guard let owner = GroupMember(json: ownerJson, role: .owner) else { return }
//                
//                var members: [GroupMember] = [owner]
//                if user.id != owner.id {
//                    members.insert(user, at: 0)
//                }
//                
//                for memberJson in membersJsonArray {
//                    if var member = GroupMember(json: memberJson, role: .member) {
//                        if member.id == user.id {
//                            member.role = .user
//                        }
//                        if member.id == owner.id {
//                            member.role = .owner
//                        }
//                        members.append(member)
//                    }
//                }
//                
//                var medias: [Media] = []
//                
//                for mediaJson in mediaJsonArray {
//                    if let media = Media(json: mediaJson) {
//                        medias.append(media)
//                    }
//                }
//                
//                let miniImage: UIImage? = DataManager.shared.getCurrentGroup()?.miniImage
//                
//                let currentGroup = Group(id: groupId, name: groupName, ownerId: owner.id, bigImage: groupImage, miniImage: miniImage, owner: owner, members: members, medias: medias)
//                DataManager.shared.setCurrentGroup(currentGroup)
//                
//                DispatchQueue.main.async { [weak self] in
//                    self?.view?.configureUIForCurrentGroup()
//                    self?.membersTable?.configureData(members: members)
//                    self?.groupMediaCollection?.configureData(medias: medias)
//                    self?.view?.updateViewsHeight()
//                    LoadingView.hide(from: self?.view)
//                    self?.view?.enableSettingsButton()
//                }
//            } else {
//                
//            }
//        } else {
//            print("something went wrong")
//            print(response)
//        }
//        DispatchQueue.main.async { [weak self] in
//            LoadingView.hide(from: self?.view)
//        }
//        
//        
//        
//    }
//}
