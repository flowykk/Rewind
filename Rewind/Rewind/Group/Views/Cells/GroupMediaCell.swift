//
//  GroupMediaCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupMediaCell: UICollectionViewCell {
    private let groupMediaView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withMediaImage image: UIImage) {
        groupMediaView.image = image
    }
}

extension GroupMediaCell {
    private func configureUI() {
        configureGroupMediaView()
    }
    
    private func configureGroupMediaView() {
        addSubview(groupMediaView)
        groupMediaView.translatesAutoresizingMaskIntoConstraints = false
        
        groupMediaView.contentMode = .scaleAspectFill
        groupMediaView.clipsToBounds = true
        groupMediaView.layer.cornerRadius = 15
        
        groupMediaView.pin(to: self)
    }
}
