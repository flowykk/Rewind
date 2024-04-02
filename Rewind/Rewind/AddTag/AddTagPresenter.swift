//
//  AddTagPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

final class AddTagPresenter {
    private weak var view: AddTagViewController?
    
    init(view: AddTagViewController?) {
        self.view = view
    }
    
    func continueButtonTapped(tagText: String?) {
        guard let tagTextToAdd = tagText, Validator.isValidTag(tagTextToAdd) else {
            AlertHelper.showAlert(from: view, withTitle: "Error", message: "The tag must be between 1 and 10 characters long")
            return
        }
        
        if view?.detailsVC != nil {
            LoadingView.show(inVC: view, backgroundColor: view?.view.backgroundColor ?? .systemBackground)
            if let mediaId = view?.mediaId, let existingTags = view?.existingTags {
                let isAlreadyExists = existingTags.contains { $0.text == tagTextToAdd }
                if !tagTextToAdd.isEmpty && !isAlreadyExists {
                    requestAddTagToMedia(mediaId: mediaId, tagText: tagTextToAdd)
                } else {
                    LoadingView.hide(fromVC: view)
                }
            } else {
                LoadingView.hide(fromVC: view)
            }
        } else if let addPhotoVC = view?.addPhotoVC, let existingTags = view?.existingTags {
            let isAlreadyExists = existingTags.contains { $0.text == tagText }
            if !tagTextToAdd.isEmpty && !isAlreadyExists {
                addPhotoVC.presenter?.addTagToCollection(Tag(id: -1, text: tagTextToAdd))
                addPhotoVC.configureUIForTags()
                addPhotoVC.updateViewsHeight()
                view?.dismiss(animated: true)
            } else {
                
            }
        } else if let addQuote = view?.addQuoteVC, let existingTags = view?.existingTags {
            let isAlreadyExists = existingTags.contains { $0.text == tagText }
            if !tagTextToAdd.isEmpty && !isAlreadyExists {
                addQuote.presenter?.addTagToCollection(Tag(id: -1, text: tagTextToAdd))
                addQuote.configureUIForTags()
                addQuote.updateViewsHeight()
                view?.dismiss(animated: true)
            } else {
                
            }
        }
    }
}

// MARK: - Network Request Funcs
extension AddTagPresenter {
    private func requestAddTagToMedia(mediaId: Int, tagText: String) {
        NetworkService.addTagToMedia(mediaId: mediaId, tagTexts: [tagText]) { [weak self] response in
            self?.handleAddTagToMediaResponseInDetails(response)
        }
    }
}

// MARK: - Network Response Handlers
extension AddTagPresenter {
    private func handleAddTagToMediaResponseInDetails(_ response: NetworkResponse) {
        if response.success, let jsonArray = response.jsonArray {
            var allTags: [Tag] = []
            
            for tagJson in jsonArray {
                if let newTag = Tag(json: tagJson) {
                    allTags.append(newTag)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.detailsVC?.presenter?.updateTagsInCollection(allTags)
                self?.view?.detailsVC?.configureUIForTags()
                self?.view?.detailsVC?.updateViewsHeight()
                self?.view?.dismiss(animated: true) {
                    LoadingView.hide(fromVC: self?.view)
                }
            }
        } else {
            print("something went wrong - handleAddTagToMediaResponse (handleAddTagToMediaResponseInDetails)")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
