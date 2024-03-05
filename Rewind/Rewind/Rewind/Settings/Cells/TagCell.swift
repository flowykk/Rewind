//
//  TagCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 05.03.2024.
//

import UIKit

class TagCell: UICollectionViewCell {
    private let titleLabel: UILabel = UILabel()
    private let deleteButton: UIButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configure(withTitle title: String) {
        titleLabel.text = title
    }
}

extension TagCell {
    private func configureUI() {
        backgroundColor = .systemGray4
        layer.cornerRadius = 20
        
        configureTitleLabel()
        configureDeleteButton()
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        titleLabel.pinLeft(to: self.leadingAnchor, 10)
        titleLabel.pinCenterY(to: self.centerYAnchor)
    }
    
    private func configureDeleteButton() {
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "minus", withConfiguration: configuration)
        deleteButton.setImage(image, for: .normal)
        
        deleteButton.tintColor = .systemBackground
        deleteButton.layer.backgroundColor = UIColor.systemGray.cgColor
        deleteButton.layer.cornerRadius = 15 / 2
        
        deleteButton.setHeight(15)
        deleteButton.pinLeft(to: titleLabel.trailingAnchor, 10)
        deleteButton.pinCenterY(to: self.centerYAnchor)
    }
}
