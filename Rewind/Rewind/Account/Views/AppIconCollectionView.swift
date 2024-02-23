//
//  AppIconCollectionView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.02.2024.
//

import UIKit

final class AppIconCollectionView: UICollectionView {
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
        register(AppIconCell.self, forCellWithReuseIdentifier: "cell")
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        setHeight(100)
    }
}

// MARK: - UICollectionViewDelegate
extension AppIconCollectionView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension AppIconCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let appIconCell = cell as? AppIconCell else { return cell }
        return appIconCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AppIconCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
    }
}
