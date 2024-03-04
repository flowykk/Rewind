//
//  TypesTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 04.03.2024.
//

import UIKit

final class TypesTableView: UITableView {
    enum TypeRow: String, CaseIterable {
        case Photos
        case Videos
        case Quotes
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
        
        setHeight(Double(Int(rowHeight) * TypeRow.allCases.count - 1))
    }
}

// MARK: - UITableViewDataSource
extension TypesTableView: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension TypesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TypeRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? SettingsCell else { return cell }
        let name = TypeRow.allCases[indexPath.row].rawValue
        let isOn = true
        customCell.configure(withName: name, isOn: isOn)
        return customCell
    }
}
