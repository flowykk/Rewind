//
//  AddPhotoRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import UIKit

final class AddPhotoRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToGallery() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = view as? AddPhotoViewController
        view?.present(imagePickerController, animated: true) { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
    
    func presentAddTag() {
        let vc = AddTagBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        if let addPhotoVC = view as? AddPhotoViewController {
            vc.addPhotoVC = addPhotoVC
            vc.existingTags = addPhotoVC.presenter?.tagsCollection?.tags
        }
        view?.present(vc, animated: true)
    }
}
