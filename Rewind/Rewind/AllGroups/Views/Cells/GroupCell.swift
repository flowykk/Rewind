//
//  GroupCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class GroupCell: UITableViewCell {
    private let groupImageView: UIImageView = UIImageView()
    private let groupNameLabel: UILabel = UILabel()
    private let chevronImageView: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        groupImageView.image = nil
        groupNameLabel.text = nil
    }
    
    func configureGroup(_ group: Group) {
        groupNameLabel.text = group.name
        
        if let groupImage = group.miniImage {
            groupImageView.image = groupImage
        } else {
            guard let defaultImage = UIImage(named: "groupImage") else { return }
            groupImageView.image = defaultImage
        }
    }
}

extension GroupCell {
    private func configureUI() {
        backgroundColor = .systemGray6
        configureGroupImageView()
        configureGroupNameLabel()
        configureChevronImageView()
    }
    
    private func configureGroupImageView() {
        addSubview(groupImageView)
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageView.contentMode = .scaleAspectFill
        groupImageView.clipsToBounds = true
        
        let width = UIScreen.main.bounds.width * 0.09
        
        groupImageView.layer.cornerRadius = width / 2
        
        groupImageView.setWidth(width)
        groupImageView.setHeight(width)
        groupImageView.pinLeft(to: leadingAnchor, 12)
        groupImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureGroupNameLabel() {
        addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        groupNameLabel.pinLeft(to: groupImageView.trailingAnchor, 12)
        groupNameLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureChevronImageView() {
        addSubview(chevronImageView)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        chevronImageView.contentMode = .scaleAspectFit
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        chevronImageView.image = image
        chevronImageView.tintColor = .blackAdapted
        
        chevronImageView.pinRight(to: trailingAnchor, 12)
        chevronImageView.pinCenterY(to: centerYAnchor)
    }
}
