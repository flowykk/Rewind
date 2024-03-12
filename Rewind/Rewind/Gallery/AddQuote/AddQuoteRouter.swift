//
//  AddQuoteRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import UIKit

final class AddQuoteRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController?) {
        self.view = view
    }
    
    func navigateToGallery() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToQuoteSettings() {
        let vc = QuoteSettingsBuilder.build()
        view?.present(vc, animated: true)
    }
    
    func presentAddTag() {
        let vc = AddTagBuilder.build()
        
        if let addQuoteView = view as? AddQuoteViewController {
            vc.addTagHandler = { tag in
                addQuoteView.presenter?.addTag(tag)
            }
            view?.present(vc, animated: true)
        }
    }
}
