//
//  ObjectInfoView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 03.03.2024.
//

import UIKit

final class ObjectInfoView: UIView {
    var viewWidth: CGFloat = UIScreen.main.bounds.width / 2 {
         didSet {
             setWidth(viewWidth)
         }
     }
    
    private let authorImageView: UIImageView = UIImageView()
    private let authorNameLabel: UILabel = UILabel()
    private let dateObjectAddedLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUIForAuthor(_ author: Author?, withDateAdded date: String?) {
        if let author = author {
            var authorImage = UIImage(named: "userImage")
            if let image = author.miniImage {
                authorImage = image
            }
            authorImageView.image = authorImage
            authorNameLabel.text = author.name
        } else {
            authorImageView.image = nil
            authorNameLabel.text = nil
        }
        if let date = date {
            dateObjectAddedLabel.text = date
        } else {
            dateObjectAddedLabel.text = nil
        }
    }
}

extension ObjectInfoView {
    private func configureUI() {
        backgroundColor = .systemBackground.withAlphaComponent(0.75)
        layer.cornerRadius = 35 / 2
        setWidth(mode: .lsOE, viewWidth)
        setHeight(35)
        
        configureAuthorImageView()
        configureDateObjectAddedLabel()
        configureAuthorNameLabel()
    }
    
    private func configureAuthorImageView() {
        addSubview(authorImageView)
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        authorNameLabel.textColor = .darkGray
        authorNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        authorNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorNameLabel.pinLeft(to: authorImageView.trailingAnchor, 5)
        authorNameLabel.pinRight(to: dateObjectAddedLabel.leadingAnchor, 5)
        authorNameLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureDateObjectAddedLabel() {
        addSubview(dateObjectAddedLabel)
        dateObjectAddedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateObjectAddedLabel.textColor = .secondaryLabel
        dateObjectAddedLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        dateObjectAddedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        dateObjectAddedLabel.pinRight(to: self.trailingAnchor, 10)
        dateObjectAddedLabel.pinCenterY(to: centerYAnchor)
    }
}
