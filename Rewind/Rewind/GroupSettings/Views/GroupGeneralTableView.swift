//
//  GroupGeneralTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupGeneralTableView: UITableView {
    weak var presenter: GroupSettingsPresenter?
    
    enum GroupGeneralRow: String, CaseIterable {
        case editGroupImage = "Edit group's image"
        case editGroupName = "Edit group's name"
        
        var imageName: String {
            switch self {
            case .editGroupImage:
                return "photo"
            case .editGroupName:
                return "pencil"
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        dataSource = self
        delegate = self
        register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        setHeight(Double(Int(rowHeight) * (GroupGeneralRow.allCases.count) - 1))
    }
}

extension GroupGeneralTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupGeneralRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? CustomTableViewCell else { return cell }
        let name = GroupGeneralRow.allCases[indexPath.row].rawValue
        let imageName = GroupGeneralRow.allCases[indexPath.row].imageName
        customCell.configure(withName: name, imageName: imageName, tintColor: .darkGray, squareColor: .systemGray4)
        return customCell
    }
}

extension GroupGeneralTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = GroupGeneralRow.allCases[indexPath.row]
        presenter?.generalRowSelected(selectedRow)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
