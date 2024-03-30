//
//  AddQuoteViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class AddQuoteViewController: UIViewController {
    var presenter: AddQuotePresenter?
    
    var currentColorSelection: ColorsTableView.ColorRow? = nil
    
    var contentViewHeightConstraint: NSLayoutConstraint?
    var tagsCollectionHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let quoteSettingsButton: UIButton = UIButton(type: .system)
    private let imageView: UIImageView = UIImageView()
    private let colorsLabel: UILabel = UILabel()
    private let colorsTable: ColorsTableView = ColorsTableView()
    private let tagsLabel: UILabel = UILabel()
    private let addTagButton: UIButton = UIButton(type: .system)
    private let tagsCollection: TagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorsTable.presenter = presenter
        tagsCollection.presenter = presenter
        presenter?.colorsTable = colorsTable
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
    private func quoteSettingsButtonTapped() {
        presenter?.quoteSettingsButtonTapped()
    }
    
    @objc
    private func addTagButtonTapped() {
        presenter?.addTagButtonTapped()
    }
    
    @objc
    private func continueButtonTapped() {
        presenter?.continueButtonTapped()
    }
    
    func configureUIForTags() {
        let attributedString = NSMutableAttributedString(string: "Tags  \(tagsCollection.tags.count)/5")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 3))
        tagsLabel.attributedText = attributedString
        
        if tagsCollection.tags.count == 5 {
            addTagButton.isHidden = true
        } else {
            addTagButton.isHidden = false
        }
    }
    
    func configureUIForColor(_ selectedColor: UIColor) {
        switch currentColorSelection {
        case .backgroundColor:
            quoteSettingsButton.backgroundColor = selectedColor
        case .textColor:
            quoteSettingsButton.tintColor = selectedColor
        case nil:
            print("do nothing")
        }
    }
    
    func configureUIForQuoteImage(image: UIImage?) {
        if let image = image {
            imageView.image = image
            quoteSettingsButton.backgroundColor = .clear
            quoteSettingsButton.setTitle(nil, for: .normal)
        }
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        tagsCollectionHeightConstraint?.isActive = false
        
        let colorsTableHeight = colorsTable.contentSize.height
        let tagsCollectionHeight = tagsCollection.collectionViewLayout.collectionViewContentSize.height
        var contentViewHeight = UIScreen.main.bounds.width - 40 + 20 + 20 + 10 + colorsTableHeight + 20 + 20 + tagsCollectionHeight + 50 + 60 + 30
        
        if contentViewHeight < (view.safeAreaLayoutGuide.layoutFrame.height + 50) {
            contentViewHeight = view.safeAreaLayoutGuide.layoutFrame.height + 50
        }
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        tagsCollectionHeightConstraint = tagsCollection.heightAnchor.constraint(equalToConstant: tagsCollectionHeight)
        
        contentViewHeightConstraint?.isActive = true
        tagsCollectionHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension AddQuoteViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        
        let selectedColor = viewController.selectedColor
        
        presenter?.colorPicked(selectedColor: selectedColor)
    }
}

// MARK: - UI Configuration
extension AddQuoteViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        
        configureBackButton()
        
        configureScrollView()
        configureContentView()
        
        configureQuoteSettingsButton()
        
        configureColorsLabel()
        configureColorsTable()
        
        configureTagsLabel()
        configureAddButton()
        configureTagsCollection()
        
        configureContinueButton()
    }
    
    private func configureBackButton() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
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
    
    private func configureQuoteSettingsButton() {
        contentView.addSubview(quoteSettingsButton)
        quoteSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        quoteSettingsButton.setTitle("Tap to view\nquote settings", for: .normal)
        quoteSettingsButton.titleLabel?.numberOfLines = 0
        quoteSettingsButton.titleLabel?.textAlignment = .center
        quoteSettingsButton.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
        quoteSettingsButton.tintColor = .systemGray
        
        quoteSettingsButton.backgroundColor = .systemGray6
        quoteSettingsButton.layer.borderWidth = 1
        quoteSettingsButton.layer.borderColor = UIColor.systemGray4.cgColor
        
        let width = UIScreen.main.bounds.width - 40
        quoteSettingsButton.layer.cornerRadius = width / 8
        
        quoteSettingsButton.addTarget(self, action: #selector(quoteSettingsButtonTapped), for: .touchUpInside)
        
        quoteSettingsButton.setWidth(width)
        quoteSettingsButton.setHeight(width)
        quoteSettingsButton.pinTop(to: contentView.topAnchor, 0)
        quoteSettingsButton.pinCenterX(to: contentView.centerXAnchor)
        
        
        quoteSettingsButton.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = quoteSettingsButton.layer.cornerRadius
        
        imageView.pinLeft(to: quoteSettingsButton.leadingAnchor)
        imageView.pinRight(to: quoteSettingsButton.trailingAnchor)
        imageView.pinTop(to: quoteSettingsButton.topAnchor)
        imageView.pinBottom(to: quoteSettingsButton.bottomAnchor)
    }
    
    private func configureColorsLabel() {
        contentView.addSubview(colorsLabel)
        colorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        colorsLabel.text = "Colors"
        colorsLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        colorsLabel.pinTop(to: quoteSettingsButton.bottomAnchor, 20)
        colorsLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureColorsTable() {
        contentView.addSubview(colorsTable)
        colorsTable.translatesAutoresizingMaskIntoConstraints = false
        
        colorsTable.pinTop(to: colorsLabel.bottomAnchor, 10)
        colorsTable.pinLeft(to: contentView.leadingAnchor, 20)
        colorsTable.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureTagsLabel() {
        contentView.addSubview(tagsLabel)
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: "Tags  0/5")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 3))
        tagsLabel.attributedText = attributedString
        
        tagsLabel.pinTop(to: colorsTable.bottomAnchor, 20)
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
        tagsCollection.pinLeft(to: view.leadingAnchor, 20)
        tagsCollection.pinRight(to: view.trailingAnchor, 20)
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
