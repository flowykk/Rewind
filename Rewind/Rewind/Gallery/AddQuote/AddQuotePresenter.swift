//
//  AddQuotePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class AddQuotePresenter: TagsCollectionPresenterProtocol {
    private weak var view: AddQuoteViewController?
    weak var tagsCollection: TagsCollectionView?
    private let router: AddQuoteRouter
    
    init(view: AddQuoteViewController?, router: AddQuoteRouter) {
        self.view = view
        self.router = router
    }
    
    func initTagsCollection() {
        tagsCollection?.tags = view?.tags ?? []
    }
    
    func backButtonTapped() {
        router.navigateToGallery()
    }
    
    func quoteSettingsButtonTapped() {
        router.navigateToQuoteSettings()
    }
    
    func addTagButtonTapped() {
        router.presentAddTag()
    }
    
    func continueButtonTapped() {
        print("add quote")
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
