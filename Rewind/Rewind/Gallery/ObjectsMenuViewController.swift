//
//  ObjectsMenuViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class ObjectsMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    private let objectsMenuTable: ObjectsMenuTableView = ObjectsMenuTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(objectsMenuTable)
        
        objectsMenuTable.translatesAutoresizingMaskIntoConstraints = false
        objectsMenuTable.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
