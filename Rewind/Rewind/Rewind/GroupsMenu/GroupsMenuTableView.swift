//
//  GroupsMenuTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupsMenuTableView: UITableView {
    
    private var groups: [String] = ["group1", "group2", "group3"]
    
    enum GroupsMenuButton: String, CaseIterable {
        case allGroups = "All groups"
        case addGroup = "Add group"
    }
    
    var rowSelected: ((String) -> Void)?
    
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
        
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        isScrollEnabled = false
        rowHeight = 40
        showsVerticalScrollIndicator = true
        showsHorizontalScrollIndicator = false
        
        let height = Double((GroupsMenuButton.allCases.count + groups.count) * Int(rowHeight))
        setHeight(height)
        setWidth(UIScreen.main.bounds.width / 2)
    }
}

extension GroupsMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + GroupsMenuButton.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = GroupsMenuButton.allGroups.rawValue
        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.textLabel?.text = GroupsMenuButton.addGroup.rawValue
        } else {
            cell.textLabel?.text = groups[indexPath.row - 1]
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return cell
    }
}


extension GroupsMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            guard let text = cell.textLabel?.text else { return }
            rowSelected?(text)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
