//
//  PropertiesTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 04.03.2024.
//

import UIKit

final class PropertiesTableView: UITableView {
    weak var presenter: SettingsPresenter?
    
    enum PropertyRow: String, CaseIterable {
        case favorites = "Only favorites"
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
        register(PropertyCell.self, forCellReuseIdentifier: "PropertyCell")
        
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        setHeight(Double(Int(rowHeight) * PropertyRow.allCases.count - 1))
    }
    
    func configureUIForSavedFilter(_ savedFilter: Filter) {
        let numberOfRows = numberOfRows(inSection: 0)
        
        for row in 0..<numberOfRows {
            if let cell = cellForRow(at: IndexPath(row: row, section: 0)) as? PropertyCell {
                switch row {
                case 0:
                    cell.configureWithState(savedFilter.onlyFavorites)
                default:
                    break
                }
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath)
        guard let customCell = cell as? PropertyCell else { return cell }
        let property = PropertyRow.allCases[indexPath.row]
        let name = property.rawValue
        customCell.configure(withName: name)
        return customCell
    }
}
