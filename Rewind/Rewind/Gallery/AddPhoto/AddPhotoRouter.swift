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
    
    func presentAddTag() {
        let vc = AddTagBuilder.build()
        
        if let addPhotoView = view as? AddPhotoViewController {
            vc.addTagHandler = { tag in
                addPhotoView.presenter?.addTag(tag)
            }
            view?.present(vc, animated: true)
        }
    }
}
