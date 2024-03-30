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
    
    func presentQuoteSettings() {
        let vc = QuoteSettingsBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        vc.addQuoteVC = view as? AddQuoteViewController
        view?.present(vc, animated: true)
    }
    
    func presentAddTag() {
        let vc = AddTagBuilder.build()
        vc.modalPresentationStyle = .custom
        if let nc = view?.navigationController {
            vc.viewDistanceTop = nc.navigationBar.frame.height + 10
        }
        if let addQuoteVC = view as? AddQuoteViewController {
            vc.addQuoteVC = addQuoteVC
            vc.existingTags = addQuoteVC.presenter?.tagsCollection?.tags
        }
        view?.present(vc, animated: true)
    }
    
    func presentColorPicker(selectedColor: UIColor) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = selectedColor
        colorPicker.delegate = view as? AddQuoteViewController
        view?.present(colorPicker, animated: true) { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
