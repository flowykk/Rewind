//
//  GeneralTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class GeneralTableView: UITableView {
    weak var presenter: AccountPresenter?
    
    private var iconName: String = ""
    
    enum GeneralRow: String, CaseIterable {
        case editImage = "Edit profile image"
        case editName = "Edit name"
        case editPassword = "Edit password"
        case editEmail = "Edit email"
        case addWidget = "Add a widget"
        case viewGroups = "View groups"
        case getHelp = "Get help"
        case share = "Share with friends"
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
        setHeight(50 * 8 - 1)
    }
}

// MARK: - UITableViewDelegate
extension GeneralTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.generalRowSelected(GeneralRow.allCases[indexPath.row])
        tableView.deselectRow(at: tableView.indexPathForSelectedRow ?? IndexPath(), animated: true)
    }
}

// MARK: - UITableViewDataSource
extension GeneralTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GeneralRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? CustomTableViewCell else { return cell }
        let name = GeneralRow.allCases[indexPath.row].rawValue
        let iconName = getIconName(fromName: name)
        customCell.configure(withName: name, iconName: iconName, tintColor: .darkGray, squareColor: .systemGray4)
        return customCell
    }
}

// MARK: - Private funcs
extension GeneralTableView {
    private func getIconName(fromName name: String) -> String {
        switch name {
        case "Edit profile image":
            return "photo"
        case "Edit name":
            return "pencil"
        case "Edit password":
            return "shield.lefthalf.filled"
        case "Edit email":
            return "envelope.fill"
        case "Add a widget":
            return "plus"
        case "View groups":
            return "eye.fill"
        case "Get help":
            return "questionmark.circle.fill"
        case "Share with friends":
            return "square.and.arrow.up.fill"
        default:
            return ""
        }
    }
}
