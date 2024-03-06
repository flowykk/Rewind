//
//  GroupsMenuTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupsMenuTableView: UITableView {
    
    private var groups: [String] = ["group1"]
    
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
        
        let height = Double((1 + groups.count) * Int(rowHeight))
        setHeight(height)
        setWidth(UIScreen.main.bounds.width / 2)
    }
}

extension GroupsMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "All groups"
        } else {
            cell.textLabel?.text = groups[indexPath.row - 1]
        }
        return cell
    }
}


extension GroupsMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
