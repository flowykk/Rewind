//
//  RewindPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 02.03.2024.
//

import Foundation
import Photos
import UIKit

final class RewindPresenter {
    private weak var view: RewindViewController?
    weak var groupsMenuTable: GroupsMenuTableView?
    private var router: RewindRouter
    
    init(view: RewindViewController?, router: RewindRouter) {
        self.view = view
        self.router = router
    }
    
    func goToGroup() {
        router.navigateToGroup()
    }
    
    func showGroupsMenuButtonTapped() {
        router.presentGroupsMenu()
    }
    
    func goToAccount() {
        router.navigateToAccount()
    }
    
    func settingsButtonTapped() {
        router.presentSettings()
    }
    
    func detailsButtonTapped() {
        router.navigateToDetails()
    }
    
    func galleryButtonTapped() {
        router.navigateToGallery()
    }
    
    func getInitialRewindScreenData() {
        LoadingView.show(in: view, backgroundColor: .white)
        var groupId = -1
        if let savedGroupId = DataManager.shared.getSaveCurrentGroupId() {
            groupId = savedGroupId
        }
        requestInitialRewindScreenData(groupId: groupId)
    }
    
    func getRandomMedia() {
        LoadingView.show(in: view, backgroundColor: .white)
        if let groupId = DataManager.shared.getCurrectGroupId() {
//            requestRandomMedia(groupId: groupId)
        } else {
            LoadingView.hide(from: view)
        }
        LoadingView.hide(from: view)
    }
    
    func favouriteButtonTapped(favourite: Bool) {
        view?.isFavourite = !favourite
        if !favourite {
            view?.setFavouriteButton(imageName: "heart.fill", tintColor: .customPink)
        } else {
            view?.setFavouriteButton(imageName: "heart", tintColor: .systemGray2)
        }
    }
    
    func menuButtonSelected(_ button: GroupsMenuTableView.GroupsMenuButton) {
        switch button {
        case .allGroups:
            router.navigateToAllGroups()
        case .addGroup:
            router.presentEnterGroupName()
        }
    }
    
    func menuGroupSelected(_ group: Group) {
        DataManager.shared.setCurrentGroup(group)
        view?.configureUIForCurrentGroup()
    }
}

extension RewindPresenter {
    func downloadButtonTapped(currentImage: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAsset(from: currentImage)}, completionHandler: { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.view?.showSuccessAlert()
                        } else if let error = error {
                            self.view?.showErrorAlert(message: error.localizedDescription)
                        }
                    }
                })
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Access to the gallery is denied or restricted")
                }
            case .limited:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Access to the gallery is limited")
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Access to the gallery is not determined")
                }
            @unknown default:
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(message: "Something went wrong")
                }
            }
        }
    }
}

// MARK: - Network Request Funcs
extension RewindPresenter {
    private func requestInitialRewindScreenData(groupId: Int) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.getInitialRewindScreenData(groupId: groupId, userId: userId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetInitialRewindScreenData(response, groupId: groupId)
            }
        }
    }
    
    private func requestRandomMedia(groupId: Int) {
        NetworkService.getRandomMedia(groupId: groupId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetRandomMediaResponse(response)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension RewindPresenter {
    private func handleGetInitialRewindScreenData(_ response: NetworkResponse, groupId: Int) {
        if response.success, let json = response.json {
            var userGroups: [Group]? = nil
            var gallerySize: Int? = nil
            var randomMedia: Media? = nil
            
            if let groups = json["groups"] as? [[String : Any]] {
                userGroups = groups.compactMap { groupDict in
                    guard let id = groupDict["id"] as? Int,
                          let name = groupDict["name"] as? String else {
                        return nil
                    }
                    
                    var miniImage: UIImage? = nil
                    if let imageString = groupDict["tinyImage"] as? String {
                        miniImage = UIImage(base64String: imageString)
                    }
                    
                    if groupId == id {
                        let currentGroup = Group(id: id, name: name, ownerId: -1, miniImage: miniImage)
                        DataManager.shared.setCurrentGroup(currentGroup)
                    }
                    
                    return Group(id: id, name: name, ownerId: -1, miniImage: miniImage)
                }
                
                DataManager.shared.setUserGroups(userGroups ?? [])
            }
            
            gallerySize = json["gallerySize"] as? Int
            randomMedia = Media(json: json["randomImage"] as? [String : Any])
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureUIForCurrentGroup()
                self?.view?.configureUIForRandomMedia(randomMedia)
                self?.view?.configureGallerySize(gallerySize)
                LoadingView.hide(from: self?.view)
            }
        } else {
            print("something went wrong")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
    
    private func handleGetRandomMediaResponse(_ response: NetworkResponse) {
        if response.success, let json = response.json {
//            print(response)
            print(json.keys)
            let randomMedia = Media(json: json)
            print("handleGetRandomMediaResponse: randomMedia id = \(String(describing: randomMedia?.id))")
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureUIForRandomMedia(randomMedia)
                LoadingView.hide(from: self?.view)
            }
        } else {
            print("something went wrong")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
}
