//
//  GalleryPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class GalleryPresenter {
    private weak var view: GalleryViewController?
    weak var galleryCollection: GalleryCollectionView?
    private var router: GalleryRouter
    
    init(view: GalleryViewController?, router: GalleryRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateBack()
    }
    
    func galleryBackButtonTapped() {
        router.navigateToRewind()
    }
    
    func addButtonTapped() {
        router.presentObjectsMenu()
    }
    
    func selectedMediaInGallery(media: Media) {
        router.presentPreview(forMedia: media.id)
    }
    
    func detailsButtonTapped(forMedia mediaId: Int) {
        router.navigateToDetails(forMedia: mediaId)
    }
    
    func selectedObjectToAdd(type: ObjectsMenuTableView.ObjectRow) {
        switch type {
        case .photo:
            router.navigateToAddPhoto()
        case .quote:
            router.navigateToAddQuote()
        }
    }
    
    func getMiniMedias() {
        guard let groupId = DataManager.shared.getCurrectGroupId() else { return }
        LoadingView.show(inVC: view, backgroundColor: .systemBackground)
        requestMiniMediaWithIdGreaterThan(mediaId: -1, groupId: groupId)
    }
}

// MARK: - Network Request Funcs
extension GalleryPresenter {
    private func requestMiniMediaWithIdGreaterThan(mediaId: Int, groupId: Int) {
        NetworkService.getMiniMediasWithIdGreaterThan(mediaId: mediaId, groupId: groupId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetMiniMediasWithIdGreaterThanResponse(response)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension GalleryPresenter {
    private func handleGetMiniMediasWithIdGreaterThanResponse(_ response: NetworkResponse) {
        if response.success, let jsonArray = response.jsonArray {
            var miniMedias: [Media] = []
            var newMedia: Media? = nil
            
            for mediaJson in jsonArray {
                newMedia = Media(json: mediaJson)
                if let newMedia = newMedia {
                    miniMedias.append(newMedia)
                }
            }
            
            galleryCollection?.miniMedias = miniMedias
            
            DataManager.shared.setCurrentGroupGallerySize(miniMedias.count)
            
            DispatchQueue.main.async { [weak self] in
                self?.galleryCollection?.reloadData()
                LoadingView.hide(fromVC: self?.view)
            }
        } else {
            print("something went wrong - handleGetMiniMediasWithIdGreaterThanResponse")
            print(response)
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToRewind()
            }
        }
    }
}
