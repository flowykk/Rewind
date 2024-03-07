//
//  GroupMediaCollectionView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupMediaCollectionView: UICollectionView {
    
    var groupMedia: [UIImage?] = [UIImage(named: "author"), UIImage(named: "bonic"), UIImage(named: "author"), UIImage(named: "bonic")]
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        dataSource = self
        delegate = self
        register(GroupMediaCell.self, forCellWithReuseIdentifier: "cell")
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        
        let height = UIScreen.main.bounds.width / 4.5 + 20
        
        setHeight(height)
    }
}

extension GroupMediaCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? GroupMediaCell else { return cell }
        if let mediaImage = groupMedia[indexPath.row] {
            customCell.configure(withMediaImage: mediaImage)
        }
        return customCell
    }
}

extension GroupMediaCollectionView: UICollectionViewDelegate {
    
}

extension GroupMediaCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = UIScreen.main.bounds.width / 4.5
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: .zero)
    }
}
