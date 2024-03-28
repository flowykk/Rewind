//
//  GalleryCollectionView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class GalleryCollectionView: UICollectionView {
    weak var galleryVC: GalleryViewController?
    
    var miniMedias: [Media] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        dataSource = self
        delegate = self
        register(GalleryCell.self, forCellWithReuseIdentifier: "cell")
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    }
}

extension GalleryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miniMedias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? GalleryCell else { return cell }
        let mediaImage = miniMedias[indexPath.row].miniImage
        customCell.configure(withImage: mediaImage)
        let side = UIScreen.main.bounds.width / 3 - 1
        customCell.layer.cornerRadius = side / 8
        return customCell
    }
}

extension GalleryCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullScreenVC = PreviewObjectBuilder.build()
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCell else { return }
        fullScreenVC.image = cell.getImage()
        fullScreenVC.modalPresentationStyle = .overCurrentContext
        fullScreenVC.modalTransitionStyle = .crossDissolve
        galleryVC?.present(fullScreenVC, animated: true)
    }
}

extension GalleryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = UIScreen.main.bounds.width / 3 - 1
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
