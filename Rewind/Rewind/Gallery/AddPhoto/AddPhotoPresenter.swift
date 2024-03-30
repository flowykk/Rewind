//
//  AddPhotoPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation
import UIKit

final class AddPhotoPresenter: TagsCollectionPresenterProtocol {
    private weak var view: AddPhotoViewController?
    weak var tagsCollection: TagsCollectionView?
    private let router: AddPhotoRouter
    
    init(view: AddPhotoViewController?, router: AddPhotoRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToGallery()
    }
    
    func loadImageButtonTapped() {
        LoadingView.show(inVC: view)
        router.presentImagePicker()
    }
    
    func imageSelected(_ image: UIImage) {
        view?.updateUIForSelectedImage(image)
    }
    
    func addTagButtonTapped() {
        router.presentAddTag()
    }
    
    func continueButtonTapped(selectedImage: UIImage?) {
        if let originalImage = selectedImage, let groupId = DataManager.shared.getCurrectGroupId(), let tagsCollection = tagsCollection {
            LoadingView.show(inVC: view)
            
            let tagTexts = tagsCollection.tags.map { $0.text }
            
            let bigImage = originalImage.resize(toDimension: 600)
            let miniImage = originalImage.resize(toDimension: 256)
            
            let bigImageData = bigImage.jpegData(compressionQuality: 1)
            let miniImageData = miniImage.jpegData(compressionQuality: 1)
            
            let bigImageB64S = bigImageData?.base64EncodedString()
            let miniImageB64S = miniImageData?.base64EncodedString()
            
            if let bigImageB64S, let miniImageB64S {
                let userId = UserDefaults.standard.integer(forKey: "UserId")
                requestLoadMediaToGroup(groupId: groupId, userId: userId, isPhoto: 1, bigImageB64String: bigImageB64S, miniImageB64String: miniImageB64S, tagTexts: tagTexts)
            }
        }
    }
    
    func addTagToCollection(_ tag: Tag) {
        tagsCollection?.tags.append(tag)
        tagsCollection?.reloadData()
    }
    
    func deleteTag(atIndex index: Int) {
        tagsCollection?.tags.remove(at: index)
        tagsCollection?.reloadData()
        view?.configureUIForTags()
        view?.updateViewsHeight()
    }
}

// MARK: - Network Request Funcs
extension AddPhotoPresenter {
    private func requestLoadMediaToGroup(groupId: Int, userId: Int, isPhoto: Int, bigImageB64String: String, miniImageB64String: String, tagTexts: [String]) {
        NetworkService.loadMediaToGroup(
            groupId: groupId,
            userId: userId,
            isPhoto: isPhoto,
            bigImageB64String: bigImageB64String,
            miniImageB64String: miniImageB64String,
            tagTexts: tagTexts
        ) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleLoadMediaToGroup(response)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension AddPhotoPresenter {
    private func handleLoadMediaToGroup(_ response: NetworkResponse) {
        if response.success {
            DataManager.shared.incrementCurrentGroupGallerySizer()
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToGallery()
            }
        } else {
            print("something went wrong - handleLoadMediaToGroup (AddPhotoPresenter)")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
