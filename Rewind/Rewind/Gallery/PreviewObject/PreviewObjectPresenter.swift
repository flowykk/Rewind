//
//  PreviewObjectPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 20.03.2024.
//

import Foundation

final class PreviewObjectPresenter {
    weak var viewController: PreviewObjectViewController?
    
    init(viewController: PreviewObjectViewController?) {
        self.viewController = viewController
    }
    
    func favouriteButtonTapped(favourite: Bool) {
        viewController?.isFavourite = !favourite
        if !favourite {
            viewController?.setFavouriteButton(imageName: "heart.fill", tintColor: .customPink)
        } else {
            viewController?.setFavouriteButton(imageName: "heart", tintColor: .darkGray)
        }
    }
}
