//
//  TagsCollectionView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 05.03.2024.
//

import UIKit

final class TagsCollectionView: UICollectionView {
    var presenter: TagsCollectionPresenterProtocol?
    
    var tags: [String] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let newLayout = LeftAlignedCollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: newLayout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        presenter?.initTagsCollection()
        delegate = self
        dataSource = self
        register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    }
}

// MARK: - UICollectionViewDataSource
extension TagsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath)
        
        guard let customCell = cell as? TagCell else { return cell }
        customCell.configure(withTitle: tags[indexPath.item])
        customCell.buttonAction = {
            self.presenter?.deleteTag(atIndex: indexPath.item)
        }
        
        return customCell
    }
}

// MARK: - UICollectionViewDelegate
extension TagsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TagsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.item]
        let tagWidth = 10 + tag.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]).width + 10 + 30 + 5
        return CGSize(width: tagWidth, height: 40)
    }
}

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
