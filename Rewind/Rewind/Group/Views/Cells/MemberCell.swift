//
//  MemberCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class MemberCell: UITableViewCell {
    private let memberImageView: UIImageView = UIImageView()
    private let memberNameLabel: UILabel = UILabel()
    private let ownerSignImageView: UIImageView = UIImageView()
    private let deleteMemberButton: UIButton = UIButton(type: .system)
    
    weak var membersTable: MembersTableView?
    private var memberId: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let left = 12 + UIScreen.main.bounds.width * 0.09 + 12
        separatorInset = UIEdgeInsets(top: .zero, left: left, bottom: .zero, right: .zero)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memberImageView.image = nil
        memberNameLabel.text = nil
        ownerSignImageView.image = nil
        deleteMemberButton.setImage(nil, for: .normal)
    }
    
    private func commonInit() {
        selectionStyle = .none
    }
    
    @objc
    private func deleteMemberButtonTapped() {
        guard let memberId = self.memberId else { return }
        membersTable?.presenter?.deleteMemberButtonTapped(memberId: memberId)
    }
    
    func configureMember(_ member: GroupMember) {
        self.memberId = member.id
        
        memberNameLabel.text = member.name
        
        if let memberImage = member.miniImage {
            memberImageView.image = memberImage
        } else {
            guard let defaultImage = UIImage(named: "userImage") else { return }
            memberImageView.image = defaultImage
        }
        
        if member.role == .owner {
            configureOwnerSign()
        } else if member.role == .member {
            configureDeleteMemberButton()
        }
    }
}

extension MemberCell {
    private func configureUI() {
        backgroundColor = .systemGray6
        configureMemberImageView()
        configureMemberNameLabel()
    }
    
    private func configureMemberImageView() {
        addSubview(memberImageView)
        memberImageView.translatesAutoresizingMaskIntoConstraints = false
        
        memberImageView.contentMode = .scaleAspectFill
        memberImageView.clipsToBounds = true
        let width = UIScreen.main.bounds.width * 0.09
        memberImageView.layer.cornerRadius = width / 2
        
        memberImageView.setWidth(width)
        memberImageView.setHeight(width)
        memberImageView.pinLeft(to: leadingAnchor, 12)
        memberImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureMemberNameLabel() {
        addSubview(memberNameLabel)
        memberNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        memberNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        memberNameLabel.pinLeft(to: memberImageView.trailingAnchor, 12)
        memberNameLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureOwnerSign() {
        addSubview(ownerSignImageView)
        ownerSignImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "star.fill", withConfiguration: configuration)
        image = image?.withTintColor(.customPink, renderingMode: .alwaysOriginal)
        ownerSignImageView.image = image
        
        ownerSignImageView.pinRight(to: trailingAnchor, 12)
        ownerSignImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureDeleteMemberButton() {
        contentView.addSubview(deleteMemberButton)
        deleteMemberButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "xmark", withConfiguration: configuration)
        image = image?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        deleteMemberButton.setImage(image, for: .normal)
        
        deleteMemberButton.addTarget(self, action: #selector(deleteMemberButtonTapped), for: .touchUpInside)
        
        deleteMemberButton.pinRight(to: trailingAnchor, 14)
        deleteMemberButton.pinCenterY(to: centerYAnchor)
    }
}
