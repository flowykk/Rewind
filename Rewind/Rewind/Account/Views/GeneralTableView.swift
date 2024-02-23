//
//  GeneralTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class GeneralTableView: UITableView {
    private let generalItems: [String] = [
        "Edit profile image",
        "Edit name",
        "Edit password",
        "Edit email",
        "Add a widget",
        "View groups",
        "Get help",
        "Share with friends"
    ]
    
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
        layer.cornerRadius = 20
        rowHeight = 50
        setHeight(50 * 8 - 1)
    }
}

// MARK: - UITableViewDelegate
extension GeneralTableView: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension GeneralTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generalItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = generalItems[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cell.backgroundColor = .systemGray6
        return cell
    }
}
