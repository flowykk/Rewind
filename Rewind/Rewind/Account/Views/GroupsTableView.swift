//
//  GroupsTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class GroupsTableView: UITableView {
    
    var groups: [String] = [
        "group",
        "group",
        "group",
        "group",
        "group",
        "group",
        "group",
        "group",
        "group",
        "group",
        "group",
        "group",
    ]
    
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

extension GroupsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + GroupsButton.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? GroupCell else { return cell }
        
        if indexPath.row == 0 {
            customCell.configureButton(.addGroup)
            return customCell
        }
        
        let name = groups[indexPath.row - 1]
        customCell.configureGroup(name: name)
        
        return customCell
    }
}

extension GroupsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
