//
//  LaunchPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import Foundation

final class LaunchPresenter {
    private weak var view: LaunchViewController?
    private var router: LaunchRouter
    
    init(view: LaunchViewController?, router: LaunchRouter) {
        self.view = view
        self.router = router
    }
    
    func viewDidAppear() {
        let isUserIDStored = UserDefaults.standard.object(forKey: "UserId")
        
        if isUserIDStored == nil {
            router.navigateToWellcome()
        } else {
            getInitialRewindScreenData()
        }
    }
    
    func getInitialRewindScreenData() {
        var groupId = -1
        
        if let stringGroupId = UserDefaults.standard.string(forKey: "CurrentGroupId"), let currentGroupId = Int(stringGroupId) {
            groupId = currentGroupId
        }
        
        requestInitialRewindScreenData(groupId: groupId)
    }
}

// MARK: - Network Request Funcs
extension LaunchPresenter {
    private func requestInitialRewindScreenData(groupId: Int) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.getInitialRewindScreenData(groupId: groupId, userId: userId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetInitialRewindScreenData(response, groupId: groupId)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension LaunchPresenter {
    private func handleGetInitialRewindScreenData(_ response: NetworkResponse, groupId: Int) {
        if response.success, let json = response.json {
            var userGroups: [Group] = []
            var randomMedia: Media? = nil
            
            if let groupsJSON = json["groups"] as? [[String : Any]] {
                for groupJSON in groupsJSON {
                    if let group = Group(json: groupJSON) {
                        userGroups.append(group)
                    }
                }
            }
            
            DataManager.shared.setUserGroups(userGroups)
            
            if let currentGroupIndex = userGroups.firstIndex(where: { $0.id == groupId }) {
                let currentGroup = userGroups[currentGroupIndex]
                DataManager.shared.setCurrentGroup(currentGroup)
                randomMedia = Media(json: json["randomImage"] as? [String : Any])
                DataManager.shared.setCurrentRandomMedia(to: randomMedia)
            } else {
                DataManager.shared.resetCurrentGroup()
                DataManager.shared.setCurrentGroupToRandomUserGroup()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.router.navigateToRewind()
            }
        } else {
            print("something went wrong - handleGetInitialRewindScreenData (LaunchPresenter")
            print(response)
        }
//        DispatchQueue.main.async { [weak self] in
//            
//        }
    }
}
