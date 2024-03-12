//
//  GalleryPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class GalleryPresenter {
    private weak var view: GalleryViewController?
    private var router: GalleryRouter
    
    init(view: GalleryViewController?, router: GalleryRouter) {
        self.view = view
        self.router = router
    }
    
    func addButtonTapped() {
        router.presentObjectsMenu()
    }
    
    func selectedObjectToAdd(type: ObjectsMenuTableView.ObjectRow) {
        switch type {
        case .photo:
            router.navigateToAddPhoto()
        case .quote:
            router.navigateToAddQuote()
        }
    }
}
