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
    
    func initTagsCollection() {
        tagsCollection?.tags = view?.tags ?? []
    }
    
    func deleteObject() {
        router.navigateToRewind()
    }
    
    func backButtonTapped() {
        router.navigateToRewind()
    }
    
    func addTagButtonTapped() {
        router.presentAddTag()
    }
    
    func objectRiskyZoneRowSelected(_ row: ObjectRiskyZoneTableView.ObjectRiskyZoneRow) {
        switch row {
        case .deleteObject: showDeleteObjectConfirmationAlert()
        }
        
    }
    
    func deleteTag(atIndex index: Int) {
        view?.tags.remove(at: index)
        view?.updateUI()
        tagsCollection?.tags = view?.tags ?? []
        tagsCollection?.reloadData()
        view?.updateViewsHeight()
    }
    
    func addTag(_ title: String) {
        view?.tags.append(title)
        view?.updateUI()
        tagsCollection?.tags = view?.tags ?? []
        tagsCollection?.reloadData()
        view?.updateViewsHeight()
    }
    
    func showDeleteObjectConfirmationAlert() {
        view?.showDeleteObjectConfirmationAlert()
    }
}
