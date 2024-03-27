//
//  MenuAddButtonCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import UIKit

final class MenuAddButtonCell: UITableViewCell {
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
        let buttonLabelFrame = buttonLabel.frame
        let left = buttonLabelFrame.origin.x
        separatorInset = UIEdgeInsets(top: .zero, left: left, bottom: .zero, right: .zero)
    }
}

extension MenuAddButtonCell {
    private func configureUI() {
        backgroundColor = .clear
        configureButtonImageView()
        configureButtonLabel()
    }
    
    private func configureButtonImageView() {
        addSubview(buttonImageView)
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonImageView.contentMode = .center
        
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "plus", withConfiguration: configuration)
        image = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        buttonImageView.image = image
        
        let width: CGFloat = 30
        
        buttonImageView.setWidth(width)
        buttonImageView.pinLeft(to: leadingAnchor, 10)
        buttonImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureButtonLabel() {
        addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.text = "Add group"
        buttonLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        buttonLabel.pinLeft(to: buttonImageView.trailingAnchor, 10)
        buttonLabel.pinCenterY(to: centerYAnchor)
    }
}
