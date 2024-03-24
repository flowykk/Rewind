//
//  GroupsTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class GroupsTableView: UITableView {
    weak var presenter: AllGroupsPresenter?
    
    var groups: [Group] = []
    
    enum GroupsButton: String, CaseIterable {
        case addGroup = "Add group"
        
        var imageName: String {
            switch self {
            case .addGroup:
                return "plus"
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        delegate = self
        dataSource = self
        register(GroupCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
    }
}

// MARK: - UITableViewDataSource
extension GroupsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + GroupsButton.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupCell
        
        if indexPath.row == 0 {
            if let buttonCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? GroupCell {
                cell = buttonCell
            } else {
                cell = GroupCell(style: .default, reuseIdentifier: "cell")
            }
            
            cell.configureButton(.addGroup)
        } else {
            if let groupCell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupCell {
                cell = groupCell
            } else {
                cell = GroupCell(style: .default, reuseIdentifier: "groupCell")
            }
            
            let name = groups[indexPath.row - 1].name
            cell.configureGroup(name: name)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GroupsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presenter?.addGroupButtonSelected()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
