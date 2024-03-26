//
//  MenuGroupCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import UIKit

final class MenuGroupCell: UITableViewCell {
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
        let buttonLabelFrame = groupNameLabel.frame
        let left = buttonLabelFrame.origin.x
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

extension MenuGroupCell {
    private func configureUI() {
        backgroundColor = .clear
        configureGroupImageView()
        configureGroupNameLabel()
        configureChevronImageView()
    }
    
    private func configureGroupImageView() {
        addSubview(groupImageView)
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageView.contentMode = .center
        groupImageView.clipsToBounds = true
        
        let width: CGFloat = 20
        
        groupImageView.layer.cornerRadius = width / 2
        
        groupImageView.setWidth(width)
        groupImageView.setHeight(width)
        groupImageView.pinLeft(to: leadingAnchor, 10)
        groupImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureGroupNameLabel() {
        addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        groupNameLabel.pinLeft(to: groupImageView.trailingAnchor, 10)
        groupNameLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureChevronImageView() {
        addSubview(chevronImageView)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        chevronImageView.contentMode = .scaleAspectFit
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        chevronImageView.image = image
        chevronImageView.tintColor = .black
        
        chevronImageView.pinRight(to: trailingAnchor, 10)
        chevronImageView.pinCenterY(to: centerYAnchor)
    }
}
