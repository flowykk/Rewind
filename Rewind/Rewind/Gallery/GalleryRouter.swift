//
//  GalleryRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import UIKit

final class GalleryRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateBack() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToRewind() {
        if let navigationController = view?.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is RewindViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
    
    func presentObjectsMenu() {
        let vc = ObjectsMenuViewController()
        
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.delegate = vc
        
        guard let galleryView = view as? GalleryViewController else { return }
        
        if let addButton = galleryView.navigationItem.rightBarButtonItem?.customView as? UIButton {
            vc.popoverPresentationController?.sourceView = addButton
            vc.popoverPresentationController?.sourceRect = CGRect(x: addButton.bounds.midX, y: addButton.bounds.maxY, width: 0, height: 0)
        }
        
        vc.presenter = galleryView.presenter
        galleryView.present(vc, animated: true)
    }
    
    func navigateToAddPhoto() {
        let vc = AddPhotoBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddQuote() {
        let vc = AddQuoteBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
