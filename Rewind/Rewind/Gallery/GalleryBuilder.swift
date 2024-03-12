//
//  GalleryBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class GalleryBuilder {
    static func build() -> GalleryViewController {
        let viewController = GalleryViewController()
        let router = GalleryRouter(view: viewController)
        let presenter = GalleryPresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
