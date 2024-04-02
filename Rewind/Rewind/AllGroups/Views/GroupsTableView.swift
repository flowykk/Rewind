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
    
    enum CellType {
        case addButton
        case group(Group)
    }
    
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
        register(AddGroupButtonCell.self, forCellReuseIdentifier: "AddGroupButtonCell")
        register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
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
        let cellType = determineCellType(tableView, for: indexPath)
        
        switch cellType {
        case .addButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddGroupButtonCell", for: indexPath)
            guard let addGroupButtonCell = cell as? AddGroupButtonCell else { return cell }
            return addGroupButtonCell
        case .group(let group):
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
            guard let groupCell = cell as? GroupCell else { return cell }
            groupCell.configureGroup(group)
            return groupCell
        }
    }
    
    private func determineCellType(_ tableView: UITableView, for indexPath: IndexPath) -> CellType {
        if indexPath.row == 0 {
            return .addButton
        } else {
            return .group(groups[indexPath.row - 1])
        }
    }
}

// MARK: - UITableViewDelegate
extension GroupsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presenter?.addGroupButtonSelected()
        } else {
            let group = groups[indexPath.row - 1]
            presenter?.groupSelected(group)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
