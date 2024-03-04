//
//  PropertiesTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 04.03.2024.
//

import UIKit

final class PropertiesTableView: UITableView {
    enum PropertyRow: String, CaseIterable {
        case favourites = "Only favourites"
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
        register(SettingsCell.self, forCellReuseIdentifier: "cell")
        
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        setHeight(Double(Int(rowHeight) * PropertyRow.allCases.count - 1))
    }
}

// MARK: - UITableViewDataSource
extension PropertiesTableView: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension PropertiesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PropertyRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? SettingsCell else { return cell }
        let name = PropertyRow.allCases[indexPath.row].rawValue
        let isOn = true
        customCell.configure(withName: name, isOn: isOn)
        return customCell
    }
}
