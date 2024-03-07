//
//  MembersTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class MembersTableView: UITableView {
    
    var members: [(name: String, type: MemberType)] = [("member1", MemberType.user), ("member2", MemberType.owner), ("member3", MemberType.member)]
    
    enum MemberType {
        case owner
        case user
        case member
    }
    
    enum MembersButton: String, CaseIterable {
        case addMember = "Add member"
        case allMembers = "All members"
        
        var imageName: String {
            switch self {
            case .addMember:
                return "person.fill.badge.plus"
            case .allMembers:
                return "eye.fill"
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
        register(MemberCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        setHeight(Double(Int(rowHeight) * (2 + members.count) - 1))
    }
}

extension MembersTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? MemberCell else { return cell }
        if indexPath.row == 0 {
            customCell.configureButton(.addMember)
            return cell
        } else if indexPath.row == members.count + 1 {
            customCell.configureButton(.allMembers)
            return cell
        }
        
        let name = members[indexPath.row - 1].name
        let type = members[indexPath.row - 1].type
        
        customCell.configureMember(name: name, type: type)
        
        return customCell
    }
}

extension MembersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
