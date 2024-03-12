//
//  AddPhotoPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class AddPhotoPresenter: TagsCollectionPresenterProtocol {
    private weak var view: AddPhotoViewController?
    weak var tagsCollection: TagsCollectionView?
    private let router: AddPhotoRouter
    
    init(view: AddPhotoViewController?, router: AddPhotoRouter) {
        self.view = view
        self.router = router
    }
    
    func initTagsCollection() {
        tagsCollection?.tags = view?.tags ?? []
    }
    
    func backButtonTapped() {
        router.navigateToGallery()
    }
    
    func addTagButtonTapped() {
        router.presentAddTag()
    }
    
    func continueButtonTapped() {
        print("add photo")
        router.navigateToGallery()
    }
    
    func addTag(_ title: String) {
        view?.tags.append(title)
        view?.updateUI()
        tagsCollection?.tags = view?.tags ?? []
        tagsCollection?.reloadData()
        view?.updateViewsHeight()
    }
    
    func deleteTag(atIndex index: Int) {
        view?.tags.remove(at: index)
        view?.updateUI()
        tagsCollection?.tags = view?.tags ?? []
        tagsCollection?.reloadData()
        view?.updateViewsHeight()
    }
}
