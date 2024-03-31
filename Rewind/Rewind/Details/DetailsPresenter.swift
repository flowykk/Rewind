//
//  DetailsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

final class DetailsPresenter: TagsCollectionPresenterProtocol {
    private weak var view: DetailsViewController?
    weak var tagsCollection: TagsCollectionView?
    private var router: DetailsRouter
    
    init(view: DetailsViewController?, router: DetailsRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToRewind()
    }
    
    func addTagButtonTapped() {
        router.presentAddTag()
    }
    
    func generateTagsButtonTapped(currentImageData: Data?) {
        LoadingView.show(inView: tagsCollection, indicatorStyle: .medium)
        if let imageData = currentImageData {
            let tagsQuantity = 5 - (tagsCollection?.tags.count ?? 0)
            requestTagsFromModel(forImageData: imageData, tagsQuantity: tagsQuantity, existingTags: tagsCollection?.tags ?? []) { [weak self] generatedTags in
                self?.handleRequestTagsFromModel(tags: generatedTags)
            }
        } else {
            LoadingView.hide(fromView: tagsCollection)
        }
    }
    
    func objectRiskyZoneRowSelected(_ row: ObjectRiskyZoneTableView.ObjectRiskyZoneRow) {
        switch row {
        case .deleteObject:
            router.presentDeleteMediaConfirmationAlert()
        }
    }
    
    func updateTagsInCollection(_ newTags: [Tag]) {
        tagsCollection?.tags = newTags
        tagsCollection?.reloadData()
    }
    
    func addTagToCollection(_ tag: Tag) {
        
    }
    
    func deleteTag(atIndex index: Int) {
        LoadingView.show(inView: tagsCollection, indicatorStyle: .medium)
        
        guard let tagTextToDelete = tagsCollection?.tags[index].text else {
            LoadingView.hide(fromVC: view)
            return
        }
        
        if let mediaId = view?.mediaId {
            requestDeleteTagFromMedia(mediaId: mediaId, tagText: tagTextToDelete)
        } else {
            LoadingView.hide(fromView: tagsCollection)
        }
    }
    
    func deleteMediaFromGroup() {
        LoadingView.show(inVC: view, backgroundColor: .systemBackground)
        if let groupId = DataManager.shared.getCurrectGroupId(), let mediaId = view?.mediaId {
            requestDeleteMediaFromGroup(groupId: groupId, mediaId: mediaId)
        } else {
            LoadingView.hide(fromVC: view)
        }
    }
    
    func getMediaInfo() {
        LoadingView.show(inVC: view, backgroundColor: .systemBackground)
        if let mediaId = view?.mediaId {
            requestMediaInfo(mediaId: mediaId)
        } else if let mediaId = view?.mediaId {
            requestMediaInfo(mediaId: mediaId)
        } else {
            LoadingView.hide(fromVC: view)
        }
    }
}

extension DetailsPresenter {
    private func requestTagsFromModel(forImageData imageData: Data, tagsQuantity: Int, existingTags: [Tag], completion: @escaping ([String]) -> Void) {
        DispatchQueue.global().async {
            if let yoloModel = yoloModel {
                yoloModel.performObjectDetection(with: imageData) { results, error in
                    if let error = error {
                        print("Error performing object detection: \(error)")
                        completion([])
                        return
                    }
                    
                    if let results = results, let resultsFirst = results.first {
                        let generatedTags = resultsFirst.labels.map { $0.identifier.replacingOccurrences(of: " ", with: "") }
                        
                        let uniqueTags = generatedTags.prefix(10).shuffled().filter { generatedTag in
                            generatedTag.count <= 15 && !existingTags.contains { $0.text == generatedTag }
                        }.prefix(tagsQuantity)
                        
                        completion(Array(uniqueTags))
                    } else {
                        print("No results found.")
                        completion([])
                    }
                }
            }
        }
    }
}

extension DetailsPresenter {
    private func handleRequestTagsFromModel(tags: [String]) {
        if !tags.isEmpty, let mediaId = view?.mediaId {
            requestAddTagToMedia(mediaId: mediaId, tagTexts: tags)
        } else {
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromView: self?.tagsCollection)
                AlertHelper.showAlert(from: self?.view, withTitle: "No Objects Detected", message: "Unfortunately, no objects were found in the photo, so tags could not be generated")
            }
        }
    }
}

// MARK: - Network Request Funcs
extension DetailsPresenter {
    private func requestMediaInfo(mediaId: Int) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.getMediaInfo(mediaId: mediaId, userId: userId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetMediaInfoResponse(response)
            }
        }
    }
    
    private func requestAddTagToMedia(mediaId: Int, tagTexts: [String]) {
        NetworkService.addTagToMedia(mediaId: mediaId, tagTexts: tagTexts) { [weak self] response in
            self?.handleAddTagToMediaResponseInDetails(response)
        }
    }
    
    private func requestDeleteTagFromMedia(mediaId: Int, tagText: String) {
        NetworkService.deleteTagFromMedia(mediaId: mediaId, tagText: tagText) { [weak self] response in
            self?.handleDeleteTagFromMediaResponse(response, tagText: tagText)
        }
    }
    
    private func requestDeleteMediaFromGroup(groupId: Int, mediaId: Int) {
        NetworkService.deleteMediaFromGroup(groupId: groupId, mediaId: mediaId) { [weak self] response in
            DispatchQueue.global().async {
                if self?.view?.rewindVC != nil {
                    self?.handleDeleteMediaFromGroupResponseFromRewind(response)
                } else if self?.view?.galleryVC != nil {
                    self?.handleDeleteMediaFromGroupResponseFromGallery(response)
                }
            }
        }
    }
}

// MARK: - Network Response Handlers
extension DetailsPresenter {
    private func handleGetMediaInfoResponse(_ response: NetworkResponse) {
        if response.success, let json = response.json {
            let currentMedia = Media(json: json)
            DispatchQueue.main.async { [weak self] in
                self?.tagsCollection?.tags = currentMedia?.tags ?? []
                self?.tagsCollection?.reloadData()
                self?.view?.configureUIForCurrentMedia(currentMedia)
                self?.view?.configureUIForTags()
                self?.view?.updateViewsHeight()
                LoadingView.hide(fromVC: self?.view)
            }
        } else {
            print("something went wrong - handleGetMediaInfo")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
    
    private func handleAddTagToMediaResponseInDetails(_ response: NetworkResponse) {
        if response.success, let jsonArray = response.jsonArray {
            var allTags: [Tag] = []
            
            for tagJson in jsonArray {
                if let newTag = Tag(json: tagJson) {
                    allTags.append(newTag)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateTagsInCollection(allTags)
                self?.view?.configureUIForTags()
                self?.view?.updateViewsHeight()
                LoadingView.hide(fromView: self?.tagsCollection)
            }
        } else {
            print("something went wrong - handleAddTagToMediaResponse (DetailsPresenter)")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromView: self?.tagsCollection)
        }
    }
    
    private func handleDeleteTagFromMediaResponse(_ response: NetworkResponse, tagText: String) {
        if response.success {
            DispatchQueue.main.async { [weak self] in
                self?.tagsCollection?.tags.removeAll(where: { $0.text == tagText })
                self?.tagsCollection?.reloadData()
                self?.view?.configureUIForTags()
                self?.view?.updateViewsHeight()
                LoadingView.hide(fromView: self?.tagsCollection)
            }
        } else {
            print("something went wrong - handleDeleteTagFromMediaResponse")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromView: self?.tagsCollection)
        }
    }
    
    private func handleDeleteMediaFromGroupResponseFromRewind(_ response: NetworkResponse) {
        if response.success {
            print("Deleted media with id: \(String(describing: view?.mediaId))")
            DataManager.shared.decrementCurrentGroupGallerySizer()
            
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToRewind()
                self?.view?.rewindVC?.presenter?.getRandomMedia()
            }
        } else {
            print("something went wrong - handleDeleteMediaFromGroup")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
    
    private func handleDeleteMediaFromGroupResponseFromGallery(_ response: NetworkResponse) {
        if response.success {
            print("Deleted media with id: \(String(describing: view?.mediaId))")
            DataManager.shared.decrementCurrentGroupGallerySizer()
            
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToGallery()
            }
        } else {
            print("something went wrong - handleDeleteMediaFromGroup")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
