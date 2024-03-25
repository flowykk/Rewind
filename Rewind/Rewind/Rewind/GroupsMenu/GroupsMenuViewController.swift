//
//  GroupsMenuViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupsMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    weak var presenter: RewindPresenter?
    
    let groupsMenuTable: GroupsMenuTableView = GroupsMenuTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(groupsMenuTable)
        
        groupsMenuTable.buttonSelected = { [weak self] button in
            self?.presenter?.buttonSelected(button)
            self?.dismiss(animated: true)
        }
        
        groupsMenuTable.groupSelected = { [weak self] group in
            self?.presenter?.groupSelected(group)
            self?.dismiss(animated: true)
        }
        
        groupsMenuTable.translatesAutoresizingMaskIntoConstraints = false
        groupsMenuTable.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
