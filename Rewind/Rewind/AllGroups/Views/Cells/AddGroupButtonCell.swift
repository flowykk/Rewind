//
//  AddGroupButtonCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import UIKit

final class AddGroupButtonCell: UITableViewCell {
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

extension AddGroupButtonCell {
    private func configureUI() {
        backgroundColor = .systemGray6
        configureButtonImageView()
        configureButtonLabel()
    }
    
    private func configureButtonImageView() {
        addSubview(buttonImageView)
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonImageView.contentMode = .center
        
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "plus", withConfiguration: configuration)
        image = image?.withTintColor(.blackAdapted, renderingMode: .alwaysOriginal)
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
        
        buttonLabel.text = "Add group"
        buttonLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        buttonLabel.pinLeft(to: buttonImageView.trailingAnchor, 12)
        buttonLabel.pinCenterY(to: centerYAnchor)
    }
}
