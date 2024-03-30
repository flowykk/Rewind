//
//  ColorCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class ColorCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()
    private let colorView: UIView = UIView()
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
        separatorInset = UIEdgeInsets(top: 0, left: titleLabel.frame.origin.x, bottom: 0, right: 0)
    }
    
    func configure(withTitle title: String, color: UIColor) {
        titleLabel.text = title
        colorView.backgroundColor = color
    }
    
    func configureWithColor(_ color: UIColor) {
        colorView.backgroundColor = color
    }
}

extension ColorCell {
    private func configureUI() {
        backgroundColor = .systemGray6
        configureTitleLabel()
        configureColorView()
        configureChevronImageView()
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        titleLabel.pinLeft(to: leadingAnchor, 20)
        titleLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureColorView() {
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        let side = self.frame.height / 2
        
        colorView.layer.cornerRadius = side / 2
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.systemGray4.cgColor
        
        colorView.setWidth(side)
        colorView.setHeight(side)
        colorView.pinLeft(to: titleLabel.trailingAnchor, 10)
        colorView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureChevronImageView() {
        addSubview(chevronImageView)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        chevronImageView.contentMode = .scaleAspectFit
        let largeFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        chevronImageView.tintColor = .black
        chevronImageView.image = image
        
        chevronImageView.pinRight(to: trailingAnchor, 12)
        chevronImageView.pinCenterY(to: centerYAnchor)
    }
}
