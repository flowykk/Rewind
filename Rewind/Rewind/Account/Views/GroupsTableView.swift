//
//  GroupsTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 01.03.2024.
//

import UIKit

final class GroupsTableView: UITableView {
    weak var presenter: AccountPresenter?
    
    enum GroupsRow: String, CaseIterable {
        case viewGroups = "View groups"
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
        setHeight(Double(50 * (GroupsRow.allCases.count) - 1))
    }
}

// MARK: - UITableViewDelegate
extension GroupsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = GroupsRow.allCases[indexPath.row]
        presenter?.groupsRowSelected(selectedRow)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension GroupsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupsRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? CustomTableViewCell else { return cell }
        let name = GroupsRow.allCases[indexPath.row].rawValue
        let iconName = getIconName(fromRow: GroupsRow.allCases[indexPath.row])
        customCell.configure(withName: name, imageName: iconName, tintColor: .darkGray, squareColor: .systemGray4)
        return customCell
    }
}

// MARK: - Private funcs
extension GroupsTableView {
    private func getIconName(fromRow row: GroupsRow) -> String {
        switch row {
        case .viewGroups:
            return "eye.fill"
        }
    }
}
