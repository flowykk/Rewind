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
        if view?.detailsVC != nil {
            LoadingView.show(inVC: view, backgroundColor: view?.view.backgroundColor ?? .systemBackground)
            if let mediaId = view?.mediaId, let existingTags = view?.existingTags, let tagTextToAdd = tagText {
                let isAlreadyExists = existingTags.contains { $0.text == tagTextToAdd }
                if !tagTextToAdd.isEmpty && !isAlreadyExists {
                    requestAddTagToMedia(mediaId: mediaId, tagText: tagTextToAdd)
                } else {
                    LoadingView.hide(fromVC: view)
                }
            } else {
                LoadingView.hide(fromVC: view)
            }
        } else if let addPhotoVC = view?.addPhotoVC, let existingTags = view?.existingTags, let tagTextToAdd = tagText {
            let isAlreadyExists = existingTags.contains { $0.text == tagText }
            if !tagTextToAdd.isEmpty && !isAlreadyExists {
                addPhotoVC.presenter?.addTagToCollection(Tag(id: -1, text: tagTextToAdd))
                addPhotoVC.configureUIForTags()
                addPhotoVC.updateViewsHeight()
                view?.dismiss(animated: true)
            } else {
                
            }
        } else if let addQuote = view?.addQuoteVC, let existingTags = view?.existingTags, let tagTextToAdd = tagText {
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
        NetworkService.addTagToMedia(mediaId: mediaId, tagText: tagText) { [weak self] response in
            self?.handleAddTagToMediaResponseInDetails(response)
        }
    }
}

// MARK: - Network Response Handlers
extension AddTagPresenter {
    private func handleAddTagToMediaResponseInDetails(_ response: NetworkResponse) {
        if response.success, let json = response.json {
            let newTag = Tag(json: json)
            DispatchQueue.main.async { [weak self] in
                if let newTag = newTag {
                    self?.view?.detailsVC?.presenter?.addTagToCollection(newTag)
                    self?.view?.detailsVC?.configureUIForTags()
                    self?.view?.detailsVC?.updateViewsHeight()
                }
                self?.view?.dismiss(animated: true) {
                    LoadingView.hide(fromVC: self?.view)
                }
            }
        } else {
            print("something went wrong - handleAddTagToMediaResponse")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
