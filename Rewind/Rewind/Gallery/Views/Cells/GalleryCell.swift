//
//  GalleryCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 20.03.2024.
//

import UIKit

final class GalleryCell: UICollectionViewCell {
    private let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withImage image: UIImage) {
        imageView.image = image
    }
    
    func getImage() -> UIImage? {
        return imageView.image
    }
}

// MARK: - UI Configuration
extension GalleryCell {
    private func configureUI() {
        configureImageView()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        imageView.setHeight(self.frame.size.height)
        imageView.setWidth(self.frame.size.width)
    }
}
