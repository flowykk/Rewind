//
//  GroupsMenuTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupsMenuTableView: UITableView {
    var groups: [Group] = []
    
    static let rowsLimit: Int = 5
    
    enum CellType {
        case addGroupButton
        case group(Group)
        case allGroupsButton
    }
    
    enum GroupsMenuButton: String, CaseIterable {
        case allGroups = "All groups"
        case addGroup = "Add group"
    }
    
    var groupSelected: ((Group) -> Void)?
    var buttonSelected: ((GroupsMenuButton) -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        groups = DataManager.shared.getUserGroups()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        delegate = self
        dataSource = self
        
        register(MenuAllGroupsButtonCell.self, forCellReuseIdentifier: "MenuAllGroupsButtonCell")
        register(MenuGroupCell.self, forCellReuseIdentifier: "MenuGroupCell")
        register(MenuAddButtonCell.self, forCellReuseIdentifier: "MenuAddButtonCell")
        
        backgroundColor = .clear
        isScrollEnabled = false
        rowHeight = 50
        showsVerticalScrollIndicator = true
        showsHorizontalScrollIndicator = false
        
        let rows = min(GroupsMenuTableView.rowsLimit, groups.count + GroupsMenuButton.allCases.count)
        let height = Double((rows) * Int(rowHeight) - (rows > 0 ? 1 : 0))
        setHeight(height)
        setWidth(UIScreen.main.bounds.width * 0.6)
    }
}

extension GroupsMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(GroupsMenuTableView.rowsLimit, groups.count + GroupsMenuButton.allCases.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = determineCellType(tableView, for: indexPath)
        
        switch cellType {
        case .allGroupsButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuAllGroupsButtonCell", for: indexPath)
            guard let allGroupsButtonCell = cell as? MenuAddButtonCell else { return cell }
            return allGroupsButtonCell
        case .group(let group):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGroupCell", for: indexPath)
            guard let groupCell = cell as? MenuGroupCell else { return cell }
            groupCell.configureGroup(group)
            return groupCell
        case .addGroupButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuAddButtonCell", for: indexPath)
            guard let addGroupButtonCell = cell as? MenuAddButtonCell else { return cell }
            return addGroupButtonCell
        }
    }
    
    private func determineCellType(_ tableView: UITableView, for indexPath: IndexPath) -> CellType {
        if indexPath.row == 0 {
            return .allGroupsButton
        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            return .addGroupButton
        } else {
            return .group(groups[indexPath.row - 1])
        }
    }
}


extension GroupsMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            buttonSelected?(.allGroups)
        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            buttonSelected?(.addGroup)
        } else {
            groupSelected?(groups[indexPath.row - 1])
        }
    }
}
