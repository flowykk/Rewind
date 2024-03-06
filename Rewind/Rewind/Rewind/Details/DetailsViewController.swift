//
//  DetailsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    var tags: [String] = []
    var tagsCollectionHeightConstraint: NSLayoutConstraint?
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let imageView: UIImageView = UIImageView()
    private let imageInfoView: ImageInfoView = ImageInfoView()
    private let tagsLabel: UILabel = UILabel()
    private let addTagButton: UIButton = UIButton(type: .system)
    private let tagsCollection: TagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let imageRiskyZoneLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewsHeight()
        configureUI()
    }
    
    @objc
    private func addTagButtonTapped() {
//        presenter?.addTagButtonTapped()
    }
    
    func updateUI() {
        let attributedString = NSMutableAttributedString(string: "Tags  \(tags.count)/5")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 3))
        tagsLabel.attributedText = attributedString
        
        if tags.count == 5 {
            addTagButton.isHidden = true
        } else {
            addTagButton.isHidden = false
        }
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        tagsCollectionHeightConstraint?.isActive = false
        
        let tagsCollectionHeight = tagsCollection.collectionViewLayout.collectionViewContentSize.height
        let contentViewHeight = 20 + (UIScreen.main.bounds.width - 20) + 30 + 30 + tagsCollectionHeight + 30 + 20
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        tagsCollectionHeightConstraint = tagsCollection.heightAnchor.constraint(equalToConstant: tagsCollectionHeight)
        
        contentViewHeightConstraint?.isActive = true
        tagsCollectionHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
}

extension DetailsViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureContentView()
        
        configureImageView()
        configureImageInfoView()
        
        configureTagsLabel()
        if tags.count < 5 { configureAddButton() }
        configureTagsCollection()
        
        configureImageRiskyZoneLabel()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinTop(to: view.topAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .systemBackground
        
        contentView.pinLeft(to: scrollView.leadingAnchor)
        contentView.pinRight(to: scrollView.trailingAnchor)
        contentView.pinTop(to: scrollView.topAnchor)
        contentView.pinBottom(to: scrollView.bottomAnchor)
        contentView.pinWidth(to: scrollView.widthAnchor)
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "bonic")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        
        imageView.setWidth(UIScreen.main.bounds.width - 20)
        imageView.setHeight(UIScreen.main.bounds.width - 20)
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        imageView.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureImageInfoView() {
        view.addSubview(imageInfoView)
        imageInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        imageInfoView.pinCenterX(to: imageView.centerXAnchor)
        imageInfoView.pinBottom(to: imageView.bottomAnchor, 5)
    }
    
    private func configureTagsLabel() {
        contentView.addSubview(tagsLabel)
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: "Tags  \(tags.count)/5")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 3))
        tagsLabel.attributedText = attributedString
        
        tagsLabel.pinTop(to: imageView.bottomAnchor, 30)
        tagsLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureAddButton() {
        contentView.addSubview(addTagButton)
        addTagButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 14, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        addTagButton.setImage(image, for: .normal)
        
        addTagButton.tintColor = .customPink
        
        addTagButton.addTarget(self, action: #selector(addTagButtonTapped), for: .touchUpInside)
        
        addTagButton.pinLeft(to: tagsLabel.trailingAnchor, 10)
        addTagButton.pinCenterY(to: tagsLabel.centerYAnchor)
    }
    
    private func configureTagsCollection() {
        contentView.addSubview(tagsCollection)
        
        tagsCollection.delaysContentTouches = false
        tagsCollection.translatesAutoresizingMaskIntoConstraints = false
        
        tagsCollection.pinTop(to: tagsLabel.bottomAnchor, 10)
        tagsCollection.pinLeft(to: contentView.leadingAnchor, 20)
        tagsCollection.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureImageRiskyZoneLabel() {
        contentView.addSubview(imageRiskyZoneLabel)
        imageRiskyZoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageRiskyZoneLabel.text = "Risky zone"
        imageRiskyZoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        imageRiskyZoneLabel.pinLeft(to: contentView.leadingAnchor, 20)
        imageRiskyZoneLabel.pinTop(to: tagsCollection.bottomAnchor, 30)
    }
}
