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
        LoadingView.show(inVC: view, backgroundColor: .white)
        var groupId = -1
        
        if let stringGroupId = UserDefaults.standard.string(forKey: "CurrentGroupId"), let currentGroupId = Int(stringGroupId) {
            groupId = currentGroupId
        }
        
        requestInitialRewindScreenData(groupId: groupId)
    }
    
    func getRandomMedia() {
        LoadingView.show(inView: view?.imageView, backgroundColor: .systemBackground)
        if let currentGroupId = DataManager.shared.getCurrectGroupId() {
            requestRandomMedia(groupId: currentGroupId)
        } else {
            LoadingView.hide(fromVC: view)
        }
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
        LoadingView.show(inView: view?.imageView, backgroundColor: .systemBackground)
        if let currentGroupId = DataManager.shared.getCurrectGroupId() {
            requestRandomMedia(groupId: currentGroupId)
        } else {
            LoadingView.hide(fromVC: view)
        }
    }
}

// MARK: - Download Image
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
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.getRandomMedia(groupId: groupId, userId: userId) { [weak self] response in
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
            } else {
                DataManager.shared.resetCurrentGroup()
                DataManager.shared.setCurrentGroupToRandomUserGroup()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureUIForCurrentGroup()
                self?.view?.configureUIForRandomMedia(randomMedia)
                LoadingView.hide(fromVC: self?.view)
            }
        } else {
            print("something went wrong")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
    
    private func handleGetRandomMediaResponse(_ response: NetworkResponse) {
        if response.success, let json = response.json {
            let randomMedia = Media(json: json)
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureUIForRandomMedia(randomMedia)
                LoadingView.hide(fromView: self?.view?.imageView)
            }
        } else if response.statusCode == 204 {
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureUIForRandomMedia(nil)
                LoadingView.hide(fromView: self?.view?.imageView)
            }
        } else {
            print("something went wrong - handleGetRandomMediaResponse")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromView: self?.view?.imageView)
        }
    }
}
