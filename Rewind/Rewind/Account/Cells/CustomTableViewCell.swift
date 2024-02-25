//
//  CustomTableViewCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.02.2024.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    private let iconBackgroundView: UIView = UIView()
    private let iconImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
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
        separatorInset = UIEdgeInsets(top: 0, left: nameLabel.frame.origin.x, bottom: 0, right: 0)
    }
    
    func configure(withName name: String, iconName: String, tintColor: UIColor, squareColor: UIColor) {
        nameLabel.text = name
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = tintColor
        nameLabel.textColor = tintColor
        chevronImageView.tintColor = tintColor
        iconBackgroundView.backgroundColor = squareColor
    }
}

// MARK: - UI Configuration
extension CustomTableViewCell {
    private func configureUI() {
        backgroundColor = .systemGray6
        configureIconBackgroundView()
        configureIconImageView()
        configureNameLabel()
        configureChevronImageView()
    }
    
    private func configureIconBackgroundView() {
        addSubview(iconBackgroundView)
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        iconBackgroundView.layer.cornerRadius = 10
        
        iconBackgroundView.pinLeft(to: leadingAnchor, 12)
        iconBackgroundView.pinCenterY(to: centerYAnchor)
        iconBackgroundView.setHeight(30)
        iconBackgroundView.setWidth(30)
    }
    
    private func configureIconImageView() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.contentMode = .scaleAspectFit
        
        iconImageView.pinCenter(to: iconBackgroundView)
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        nameLabel.pinLeft(to: iconBackgroundView.trailingAnchor, 12)
        nameLabel.pinCenterY(to: iconBackgroundView.centerYAnchor)
    }
    
    private func configureChevronImageView() {
        addSubview(chevronImageView)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        chevronImageView.contentMode = .scaleAspectFit
        let largeFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        chevronImageView.image = image
        
        chevronImageView.pinRight(to: trailingAnchor, 12)
        chevronImageView.pinCenterY(to: centerYAnchor)
    }
}
