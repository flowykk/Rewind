//
//  AppIconCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class AppIconCell: UICollectionViewCell {
    private let appIconView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withImage name: String) {
        appIconView.image = UIImage(named: name)
    }
    
    func makeSelected() {
        layer.borderColor = UIColor.systemTeal.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 10
    }
}

// MARK: - UI Configuration
extension AppIconCell {
    private func configureUI() {
        configureAppIconView()
    }
    
    private func configureAppIconView() {
        addSubview(appIconView)
        appIconView.translatesAutoresizingMaskIntoConstraints = false
        
        appIconView.contentMode = .scaleAspectFill
        appIconView.clipsToBounds = true
        appIconView.layer.cornerRadius = 10
        
        appIconView.pinCenter(to: self)
        appIconView.setWidth(70)
        appIconView.setHeight(70)
    }
}
