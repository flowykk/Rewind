//
//  GroupRiskyZoneTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupRiskyZoneTableView: UITableView {
    weak var presenter: GroupSettingsPresenter?
    
    private var isDeleteButtonShown: Bool = false
    
    enum GroupRiskyZoneRow: String, CaseIterable {
        case leaveGroup = "Leave group"
        case deleteGroup = "Delete group"
        
        var imageName: String {
            switch self {
            case .leaveGroup:
                return "rectangle.portrait.and.arrow.forward.fill"
            case .deleteGroup:
                return "xmark.bin.fill"
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
        delegate = self
        dataSource = self
        register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        let dop = DataManager.shared.getCurrentGroup()
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        if let ownerId = dop?.ownerId {
            if userId == ownerId {
                setHeight(Double(Int(rowHeight) * (2) - 1))
                isDeleteButtonShown = true
            } else {
                setHeight(Double(Int(rowHeight) * (1) - 1))
            }
        } else {
            setHeight(Double(Int(rowHeight) * (1) - 1))
        }
    }
}

// MARK: - UITableViewDataSource
extension GroupRiskyZoneTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDeleteButtonShown {
            return GroupRiskyZoneRow.allCases.count
        }
        return GroupRiskyZoneRow.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? CustomTableViewCell else { return cell }
        let name = GroupRiskyZoneRow.allCases[indexPath.row].rawValue
        let imageName = GroupRiskyZoneRow.allCases[indexPath.row].imageName
        customCell.configure(withName: name, imageName: imageName, tintColor: .systemRed, squareColor: .systemRed.withAlphaComponent(0.3))
        return customCell
    }
}

// MARK: - UITableViewDelegate
extension GroupRiskyZoneTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = GroupRiskyZoneRow.allCases[indexPath.row]
        presenter?.riskyZoneRowSelected(selectedRow)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
