//
//  DetailsRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class DetailsRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToRewind() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentAddTag() {
        let vc = AddTagBuilder.build()
        if let detailsView = view as? DetailsViewController {
            vc.addTagHandler = { tag in
                detailsView.presenter?.addTag(tag)
            }
            view?.present(vc, animated: true)
        }
    }
}
