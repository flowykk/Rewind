//
//  PreviewObjectRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import UIKit

final class PreviewObjectRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController? = nil) {
        self.view = view
    }
    
    func navigateToDetails() {
        if let previewVC = view as? PreviewObjectViewController, let mediaId = previewVC.mediaId {
            view?.dismiss(animated: true) {
                previewVC.galleryVC?.presenter?.detailsButtonTapped(forMedia: mediaId)
            }
        }
    }
    
    func presentShareVC(imageToShare: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [.postToFacebook, .addToReadingList, .assignToContact, .print,]
        
        view?.present(activityVC, animated: true) { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
