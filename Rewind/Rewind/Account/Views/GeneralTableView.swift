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
        case editEmail = "Edit email"
        case editPassword = "Edit password"
//        case addWidget = "Add a widget"
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
        setHeight(Double(50 * (GeneralRow.allCases.count) - 1))
    }
}

// MARK: - UITableViewDelegate
extension GeneralTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = GeneralRow.allCases[indexPath.row]
        presenter?.generalRowSelected(selectedRow)
        tableView.deselectRow(at: indexPath, animated: true)
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
        let iconName = getIconName(fromRow: GeneralRow.allCases[indexPath.row])
        customCell.configure(withName: name, iconName: iconName, tintColor: .darkGray, squareColor: .systemGray4)
        return customCell
    }
}

// MARK: - Private funcs
extension GeneralTableView {
    private func getIconName(fromRow row: GeneralRow) -> String {
        switch row {
        case .editImage:
            return "photo"
        case .editName:
            return "pencil"
        case .editEmail:
            return "envelope.fill"
        case .editPassword:
            return "shield.lefthalf.filled"
        case .getHelp:
            return "questionmark.circle.fill"
        case .share:
            return "square.and.arrow.up.fill"
        }
    }
}
