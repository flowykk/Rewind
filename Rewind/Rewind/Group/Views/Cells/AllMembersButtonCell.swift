//
//  AddButtonCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import UIKit

final class AllMembersButtonCell: UITableViewCell {
    private let buttonImageView: UIImageView = UIImageView()
    private let buttonLabel: UILabel = UILabel()
    
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
}

extension AllMembersButtonCell {
    private func configureUI() {
        backgroundColor = .systemGray6
        configureButtonImageView()
        configureButtonLabel()
    }
    
    private func configureButtonImageView() {
        addSubview(buttonImageView)
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonImageView.contentMode = .center
        
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "eye.fill", withConfiguration: configuration)
        image = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        buttonImageView.image = image
        
        let width = UIScreen.main.bounds.width * 0.09
        
        buttonImageView.layer.cornerRadius = width / 2
        
        buttonImageView.setWidth(width)
        buttonImageView.pinLeft(to: leadingAnchor, 12)
        buttonImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureButtonLabel() {
        addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.text = "All members"
        buttonLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        buttonLabel.pinLeft(to: buttonImageView.trailingAnchor, 12)
        buttonLabel.pinCenterY(to: centerYAnchor)
    }
}
