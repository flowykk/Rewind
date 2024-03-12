//
//  DetailsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    var presenter: DetailsPresenter?
    
    var tags: [String] = []
    var tagsCollectionHeightConstraint: NSLayoutConstraint?
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let objectView: UIImageView = UIImageView()
    private let objectInfoView: ObjectInfoView = ObjectInfoView()
    private let tagsLabel: UILabel = UILabel()
    private let addTagButton: UIButton = UIButton(type: .system)
    private let tagsCollection: TagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let objectRiskyZoneLabel: UILabel = UILabel()
    private let objectRiskyZoneTabel: ObjectRiskyZoneTableView = ObjectRiskyZoneTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsCollection.presenter = presenter
        objectRiskyZoneTabel.presenter = presenter
        presenter?.tagsCollection = tagsCollection
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewsHeight()
    }
    
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    @objc
    private func addTagButtonTapped() {
        presenter?.addTagButtonTapped()
    }
    
    func showDeleteObjectConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Confirm Delete",
            message: "Are you sure you want to delete this object? You will not be able to undo this action in the future",
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presenter?.deleteObject()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
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
        configureTagsCollection()
        
        configureObjectRiskyZoneLabel()
        configureObjectRiskyZoneTabel()
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
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
    }
    
    private func configureObjectView() {
        contentView.addSubview(objectView)
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.image = UIImage(named: "bonic")
        objectView.contentMode = .scaleAspectFill
        objectView.clipsToBounds = true
        objectView.layer.cornerRadius = 40
        
        objectView.setWidth(UIScreen.main.bounds.width - 20)
        objectView.setHeight(UIScreen.main.bounds.width - 20)
        objectView.pinTop(to: contentView.topAnchor)
        objectView.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureObjectInfoView() {
        contentView.addSubview(objectInfoView)
        objectInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        objectInfoView.pinCenterX(to: objectView.centerXAnchor)
        objectInfoView.pinBottom(to: objectView.bottomAnchor, 5)
    }
    
    private func configureTagsLabel() {
        contentView.addSubview(tagsLabel)
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: "Tags  \(tags.count)/5")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 3))
        tagsLabel.attributedText = attributedString
        
        tagsLabel.pinTop(to: objectView.bottomAnchor, 30)
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
