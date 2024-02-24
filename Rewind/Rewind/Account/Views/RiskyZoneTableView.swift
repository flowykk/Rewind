//
//  RiskyZoneTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class RiskyZoneTableView: UITableView {
    private let riskyZoneItems: [String] = [
        "Log out",
        "Delete account"
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
        register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        setHeight(50 * 2 - 1)
    }
}

// MARK: - UITableViewDelegate
extension RiskyZoneTableView: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension RiskyZoneTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        riskyZoneItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? CustomTableViewCell else { return cell }
        let name = riskyZoneItems[indexPath.row]
        let iconName = getIconName(fromName: name)
        customCell.configure(withName: name, iconName: iconName, tintColor: .systemRed, squareColor: .systemRed.withAlphaComponent(0.3))
        return customCell
    }
}

// MARK: - Private funcs
extension RiskyZoneTableView {
    private func getIconName(fromName name: String) -> String {
        switch name {
        case "Log out":
            return "rectangle.portrait.and.arrow.forward.fill"
        case "Delete account":
            return "xmark.bin.fill"
        default:
            return ""
        }
    }
}
