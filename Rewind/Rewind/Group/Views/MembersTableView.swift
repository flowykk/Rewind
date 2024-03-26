//
//  MembersTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class MembersTableView: UITableView {
    var presenter: AllMembersTablePresenterProtocol?
    
    var members: [GroupMember] = []
    
    var isAllMembersButtonShown: Bool = true
    var isLimitedDisplay: Bool = false
    
    private var limitedDisplayRows: Int = 10
    
    enum CellType {
        case addButton
        case member(GroupMember)
        case allMembersButton
    }
    
    enum MembersButton: String, CaseIterable {
        case addMember = "Add member"
        case allMembers = "All members"
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
        register(AddButtonCell.self, forCellReuseIdentifier: "AddButtonCell")
        register(MemberCell.self, forCellReuseIdentifier: "MemberCell")
        register(AllMembersButtonCell.self, forCellReuseIdentifier: "AllMembersButtonCell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
    }
    
    func configureData(members: [GroupMember]) {
        self.members = members
        reloadData()
    }
}

// MARK: - UITableViewDataSource
extension MembersTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = members.count + MembersButton.allCases.count
        rows -= isAllMembersButtonShown ? 0 : 1
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = determineCellType(tableView, for: indexPath)
        
        switch cellType {
        case .addButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddButtonCell", for: indexPath)
            guard let addButtonCell = cell as? AddButtonCell else { return cell }
            return addButtonCell
        case .allMembersButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllMembersButtonCell", for: indexPath)
            guard let addButtonCell = cell as? AllMembersButtonCell else { return cell }
            return addButtonCell
        case .member(let member):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
            guard let memberCell = cell as? MemberCell else { return cell }
            memberCell.membersTable = self
            memberCell.configureMember(member)
            return memberCell
        }
    }
    
    private func determineCellType(_ tableView: UITableView, for indexPath: IndexPath) -> CellType {
        if indexPath.row == 0 {
            return .addButton
        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            if isAllMembersButtonShown {
                return .allMembersButton
            } else {
                return .member(members[indexPath.row - 1])
            }
        } else {
            return .member(members[indexPath.row - 1])
        }
    }
}

// MARK: - UITableViewDelegate
extension MembersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = determineCellType(tableView, for: indexPath)
        presenter?.rowSelected(row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
