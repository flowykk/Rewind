//
//  AddPhotoViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class AddPhotoViewController: UIViewController {
    var tags: [String] = []
    var contentViewHeightConstraint: NSLayoutConstraint?
    var tagsCollectionHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let loadImageButton: UIButton = UIButton(type: .system)
    private let tagsLabel: UILabel = UILabel()
    private let addTagButton: UIButton = UIButton(type: .system)
    private let tagsCollection: TagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewsHeight()
    }
    
    @objc
    private func addTagButtonTapped() {
        print("add tag")
    }
    
    @objc
    private func continueButtonTapped() {
        print("save photo")
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
        
        let loadImageButtonHeight = loadImageButton.frame.height
        let tagsCollectionHeight = tagsCollection.collectionViewLayout.collectionViewContentSize.height
        
        let contentViewHeight = loadImageButtonHeight + 20 + 20 + 10 + tagsCollectionHeight
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        tagsCollectionHeightConstraint = tagsCollection.heightAnchor.constraint(equalToConstant: tagsCollectionHeight)
        
        contentViewHeightConstraint?.isActive = true
        tagsCollectionHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
}

extension AddPhotoViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        
        configureBackButton()
        
        configureScrollView()
        configureContentView()
        
        configureLoadImageButton()
        
        configureTagsLabel()
        if tags.count < 5 { configureAddButton() }
        configureTagsCollection()
        
        configureContinueButton()
    }
    
    private func configureBackButton() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .black
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
        contentView.setHeight(view.frame.size.height)
    }
    
    private func configureLoadImageButton() {
        contentView.addSubview(loadImageButton)
        loadImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        loadImageButton.setTitle("Tap to load photo", for: .normal)
        loadImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        loadImageButton.tintColor = .systemGray
        
        loadImageButton.backgroundColor = .systemGray6
        
        let width = UIScreen.main.bounds.width - 40
        loadImageButton.layer.cornerRadius = width / 8
        
        loadImageButton.setWidth(width)
        loadImageButton.setHeight(width)
        loadImageButton.pinTop(to: contentView.topAnchor, 0)
        loadImageButton.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureTagsLabel() {
        contentView.addSubview(tagsLabel)
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: "Tags  \(tags.count)/5")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 3))
        tagsLabel.attributedText = attributedString
        
        tagsLabel.pinTop(to: loadImageButton.bottomAnchor, 20)
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
    
    private func configureContinueButton() {
        contentView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.customPink, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        continueButton.layer.borderColor = UIColor.customPink.cgColor
        continueButton.layer.borderWidth = 4
        continueButton.layer.cornerRadius = 30
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        continueButton.pinTop(to: tagsCollection.bottomAnchor, 50)
        continueButton.pinCenterX(to: contentView.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}

