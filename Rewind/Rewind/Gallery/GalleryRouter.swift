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
    
    func navigateToDetails(forMedia mediaId: Int) {
        let vc = DetailsBuilder.build()
        if let galleryVC = view as? GalleryViewController {
            vc.galleryVC = galleryVC
            vc.mediaId = mediaId
        }
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentPreview(forMedia mediaId: Int) {
        let vc = PreviewObjectBuilder.build()
        vc.mediaId = mediaId
        vc.galleryVC = view as? GalleryViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        view?.present(vc, animated: true)
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
