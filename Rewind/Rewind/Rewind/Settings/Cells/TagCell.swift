//
//  TagCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 05.03.2024.
//

import UIKit

final class TagCell: UICollectionViewCell {
    private let titleLabel: UILabel = UILabel()
    private let deleteButton: UIButton = UIButton(type: .system)
    
    var buttonAction: (() -> Void)?
    
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
    
    @objc
    private func buttonTapped() {
        buttonAction?()
    }
}

extension TagCell {
    private func configureUI() {
        backgroundColor = .systemGray6
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
        
        deleteButton.tintColor = .systemGray
        deleteButton.layer.backgroundColor = UIColor.systemGray5.cgColor
        deleteButton.layer.cornerRadius = 30 / 2
        
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        deleteButton.setWidth(30)
        deleteButton.setHeight(30)
        deleteButton.pinRight(to: self.trailingAnchor, 5)
        deleteButton.pinCenterY(to: self.centerYAnchor)
    }
}
