//
//  GroupsMenuViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupsMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    private let groupsMenuTable: GroupsMenuTableView = GroupsMenuTableView()
    
    var rowSelectionHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(groupsMenuTable)
        
        groupsMenuTable.rowSelected = rowSelectionHandler
        
        groupsMenuTable.translatesAutoresizingMaskIntoConstraints = false
        groupsMenuTable.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
