//
//  ImageInfoView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 03.03.2024.
//

import UIKit

final class ImageInfoView: UIView {
    private let authorImageView: UIImageView = UIImageView()
    private let authorNameLabel: UILabel = UILabel()
    private let dateImageAddedLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageInfoView {
    private func configureUI() {
        backgroundColor = UIColor(white: 0.7, alpha: 0.9)
        layer.cornerRadius = 35 / 2
        setWidth(160)
        setHeight(35)
        
        configureAuthorImageView()
        configureAuthorNameLabel()
        configureDateImageAddedLabel()
    }
    
    private func configureAuthorImageView() {
        addSubview(authorImageView)
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        authorImageView.image = UIImage(named: "author")
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = 15
        
        authorImageView.setWidth(30)
        authorImageView.setHeight(30)
        authorImageView.pinLeft(to: leadingAnchor, 3)
        authorImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureAuthorNameLabel() {
        addSubview(authorNameLabel)
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorNameLabel.text = "aleksandra"
        authorNameLabel.textColor = .darkGray
        authorNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        authorNameLabel.setWidth(60)
        authorNameLabel.pinLeft(to: authorImageView.trailingAnchor, 5)
        authorNameLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureDateImageAddedLabel() {
        addSubview(dateImageAddedLabel)
        dateImageAddedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateImageAddedLabel.text = "7 Jan"
        dateImageAddedLabel.textColor = .secondaryLabel
        dateImageAddedLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        dateImageAddedLabel.setWidth(60)
        dateImageAddedLabel.pinLeft(to: authorNameLabel.trailingAnchor, 5)
        dateImageAddedLabel.pinCenterY(to: centerYAnchor)
    }
}
