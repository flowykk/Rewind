//
//  TypesTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 04.03.2024.
//

import UIKit

final class TypesTableView: UITableView {
    weak var presenter: SettingsPresenter?
    
    enum TypeRow: String, CaseIterable {
        case Photos
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
        register(TypeCell.self, forCellReuseIdentifier: "TypeCell")
        
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        setHeight(Double(Int(rowHeight) * TypeRow.allCases.count - 1))
    }
    
    func configureUIForSavedFilter(_ savedFilter: Filter) {
        let numberOfRows = numberOfRows(inSection: 0)

        for row in 0..<numberOfRows {
            if let cell = cellForRow(at: IndexPath(row: row, section: 0)) as? TypeCell {
                switch row {
                case 0:
                    cell.configureWithState(savedFilter.includePhotos)
                case 1:
                    cell.configureWithState(savedFilter.includeQuotes)
                default:
                    break
                }
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
        guard let customCell = cell as? TypeCell else { return cell }
        let type = TypeRow.allCases[indexPath.row]
        let name = type.rawValue
        customCell.configure(withName: name, type: type)
        return customCell
    }
}
