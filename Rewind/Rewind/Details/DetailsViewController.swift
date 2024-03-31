//
//  DetailsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    var presenter: DetailsPresenter?
    
    var rewindVC: RewindViewController?
    var galleryVC: GalleryViewController?
    
    var mediaId: Int?
    
    var tags: [String] = []
    var tagsCollectionHeightConstraint: NSLayoutConstraint?
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let imageView: UIImageView = UIImageView()
    private let imageInfoView: ObjectInfoView = ObjectInfoView()
    private let tagsLabel: UILabel = UILabel()
    private let addTagButton: UIButton = UIButton(type: .system)
    private let generateTagsButton: UIButton = UIButton(type: .system)
    private let tagsCollection: TagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let objectRiskyZoneLabel: UILabel = UILabel()
    private let objectRiskyZoneTabel: ObjectRiskyZoneTableView = ObjectRiskyZoneTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsCollection.presenter = presenter
        objectRiskyZoneTabel.presenter = presenter
        presenter?.tagsCollection = tagsCollection
        configureUI()
        presenter?.getMediaInfo()
    }
    
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    @objc
    private func addTagButtonTapped() {
        presenter?.addTagButtonTapped()
    }
    
    @objc
    private func generateTagsButtonTapped() {
        let imageData = imageView.image?.jpegData(compressionQuality: 1)
        presenter?.generateTagsButtonTapped(currentImageData: imageData)
    }
    
    func configureUIForCurrentMedia(_ currentMedia: Media?) {
        imageView.image = currentMedia?.bigImage ?? UIImage(named: "defaultImage")
        imageInfoView.configureUIForAuthor(currentMedia?.author, withDateAdded: currentMedia?.dateAdded)
    }
    
    func configureUIForTags() {
        let attributedString = NSMutableAttributedString(string: "Tags  \(tagsCollection.tags.count)/5")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 3))
        tagsLabel.attributedText = attributedString
        
        if tagsCollection.tags.count == 5 {
            addTagButton.isHidden = true
            generateTagsButton.isHidden = true
        } else {
            addTagButton.isHidden = false
            generateTagsButton.isHidden = false
        }
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        tagsCollectionHeightConstraint?.isActive = false
        
        let tagsCollectionHeight = tagsCollection.collectionViewLayout.collectionViewContentSize.height
        let contentViewHeight = 20 + 40 + (UIScreen.main.bounds.width - 20) + 30 + 30 + 10 + tagsCollectionHeight + 30 + 20 + 10 + 50
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        tagsCollectionHeightConstraint = tagsCollection.heightAnchor.constraint(equalToConstant: tagsCollectionHeight)
        
        contentViewHeightConstraint?.isActive = true
        tagsCollectionHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
}

extension DetailsViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        
        configureBackButton()
        
        configureScrollView()
        configureContentView()
        
        configureObjectView()
        configureObjectInfoView()
        
        configureTagsLabel()
        if tags.count < 5 { configureAddButton() }
        configureGenerateTagsButton()
        configureTagsCollection()
        
        configureObjectRiskyZoneLabel()
        configureObjectRiskyZoneTabel()
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .blackAdapted
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
        
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
    
    private func configureObjectView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        
        imageView.setWidth(UIScreen.main.bounds.width - 20)
        imageView.setHeight(UIScreen.main.bounds.width - 20)
        imageView.pinTop(to: contentView.topAnchor)
        imageView.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureObjectInfoView() {
        contentView.addSubview(imageInfoView)
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
    
    private func configureGenerateTagsButton() {
        contentView.addSubview(generateTagsButton)
        generateTagsButton.translatesAutoresizingMaskIntoConstraints = false
        
        generateTagsButton.setTitle("autogenerate", for: .normal)
        generateTagsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        generateTagsButton.tintColor = .customPink
        generateTagsButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        generateTagsButton.addTarget(self, action: #selector(generateTagsButtonTapped), for: .touchUpInside)
        
        generateTagsButton.pinBottom(to: tagsLabel.bottomAnchor)
        generateTagsButton.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureTagsCollection() {
        contentView.addSubview(tagsCollection)
        
        tagsCollection.delaysContentTouches = false
        tagsCollection.translatesAutoresizingMaskIntoConstraints = false
        
        tagsCollection.pinTop(to: tagsLabel.bottomAnchor, 10)
        tagsCollection.pinLeft(to: contentView.leadingAnchor, 20)
        tagsCollection.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureObjectRiskyZoneLabel() {
        contentView.addSubview(objectRiskyZoneLabel)
        objectRiskyZoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        objectRiskyZoneLabel.text = "Risky zone"
        objectRiskyZoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        objectRiskyZoneLabel.pinLeft(to: contentView.leadingAnchor, 20)
        objectRiskyZoneLabel.pinTop(to: tagsCollection.bottomAnchor, 30)
    }
    
    private func configureObjectRiskyZoneTabel() {
        contentView.addSubview(objectRiskyZoneTabel)
        objectRiskyZoneTabel.translatesAutoresizingMaskIntoConstraints = false
        
        objectRiskyZoneTabel.pinTop(to: objectRiskyZoneLabel.bottomAnchor, 10)
        objectRiskyZoneTabel.pinLeft(to: contentView.leadingAnchor, 20)
        objectRiskyZoneTabel.pinRight(to: contentView.trailingAnchor, 20)
    }
}
