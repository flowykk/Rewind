//
//  ObjectsMenuViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class ObjectsMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var presenter: GalleryPresenter?
    
    private let objectsMenuTable: ObjectsMenuTableView = ObjectsMenuTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = Double(2 * 40)
        
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width / 2, height: height)
        popoverPresentationController?.permittedArrowDirections = []
        
        view.backgroundColor = .systemBackground
        view.addSubview(objectsMenuTable)
        
        objectsMenuTable.selectedRow = { [weak self] type in
            self?.dismiss(animated: true)
            self?.presenter?.selectedObjectToAdd(type: type)
        }
        
        objectsMenuTable.translatesAutoresizingMaskIntoConstraints = false
        objectsMenuTable.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
