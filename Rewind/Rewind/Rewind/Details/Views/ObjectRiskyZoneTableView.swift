//
//  ObjectRiskyZoneTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class ObjectRiskyZoneTableView: UITableView {
    weak var presenter: DetailsPresenter?
    
    enum ObjectRiskyZoneRow: String, CaseIterable {
        case deleteObject = "Delete object"
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
        register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        setHeight(Double(50 * (ObjectRiskyZoneRow.allCases.count) - 1))
    }
}

// MARK: - UITableViewDelegate
extension ObjectRiskyZoneTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = ObjectRiskyZoneRow.allCases[indexPath.row]
        presenter?.objectRiskyZoneRowSelected(selectedRow)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ObjectRiskyZoneTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ObjectRiskyZoneRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? CustomTableViewCell else { return cell }
        let row = ObjectRiskyZoneRow.allCases[indexPath.row]
        let iconName = getIconName(fromRow: row)
        customCell.configure(withName: row.rawValue, imageName: iconName, tintColor: .systemRed, squareColor: .systemRed.withAlphaComponent(0.3))
        return customCell
    }
}

// MARK: - Private funcs
extension ObjectRiskyZoneTableView {
    private func getIconName(fromRow row: ObjectRiskyZoneRow) -> String {
        switch row {
        case .deleteObject:
            return "xmark.bin.fill"
        }
    }
}
