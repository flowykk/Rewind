//
//  RewindViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 02.03.2024.
//

import UIKit

final class RewindViewController: UIViewController {
    var presenter: RewindPresenter?
    
    private let goToGroupButton: UIButton = UIButton(type: .system)
    private let currentGroupView: UIView = UIView()
    private let goToAccountButton: UIButton = UIButton(type: .system)
    
    private let imageView: UIImageView = UIImageView()
    private let imageInfoView: ImageInfoView = ImageInfoView()
    
    private let settingsButton: UIButton = UIButton(type: .system)
    private let detailsButton: UIButton = UIButton(type: .system)
    
    private let downloadButton: UIButton = UIButton(type: .system)
    private let rewindButton: UIButton = UIButton(type: .system)
    private let favouriteButton: UIButton = UIButton(type: .system)
    
    private let galleryButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc
    private func goToAccountButtonTapped() {
        presenter?.goToAccount()
    }
}

// MARK: - UI Configuration
extension RewindViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureGoToGroupButton()
        configureCurrentGroupView()
        configureGoToAccountButton()
        configureImageView()
        configureImageInfoView()
        configureDetailsButton()
        configureSettingsButton()
        configureRewindButton()
        configureGalleryButton()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: goToGroupButton)
        navigationItem.titleView = currentGroupView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: goToAccountButton)
    }
    
    private func configureGoToGroupButton() {
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "person.2.fill", withConfiguration: configuration)
        goToGroupButton.setImage(image, for: .normal)
        
        goToGroupButton.tintColor = .darkGray
        goToGroupButton.backgroundColor = .systemGray6
        goToGroupButton.layer.cornerRadius = 40 / 2
        
        goToGroupButton.setWidth(40)
        goToGroupButton.setHeight(40)
    }
    
    private func configureCurrentGroupView() {
        currentGroupView.translatesAutoresizingMaskIntoConstraints = false
        
        currentGroupView.backgroundColor = .systemGray6
        currentGroupView.layer.cornerRadius = 40 / 2
        
        currentGroupView.setWidth(170)
        currentGroupView.setHeight(40)
        
        
        let groupImageView = UIImageView()
        currentGroupView.addSubview(groupImageView)
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageView.image = UIImage(named: "groupImage")
        groupImageView.contentMode = .scaleAspectFill
        groupImageView.clipsToBounds = true
        groupImageView.layer.cornerRadius = 35 / 2
        
        groupImageView.setWidth(35)
        groupImageView.setHeight(35)
        groupImageView.pinLeft(to: currentGroupView.leadingAnchor, 3)
        groupImageView.pinCenterY(to: currentGroupView.centerYAnchor)
        
        
        let showListButton = UIButton(type: .system)
        currentGroupView.addSubview(showListButton)
        showListButton.translatesAutoresizingMaskIntoConstraints = false
        
        showListButton.setTitle("curr group", for: .normal)
        showListButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 11, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        showListButton.setImage(image, for: .normal)
        
        showListButton.tintColor = .darkGray
        showListButton.semanticContentAttribute = .forceRightToLeft
        showListButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        showListButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: -35)
        
        showListButton.setHeight(35)
        showListButton.pinLeft(to: currentGroupView.leadingAnchor, 5)
        showListButton.pinRight(to: currentGroupView.trailingAnchor, 5)
        showListButton.pinCenterY(to: currentGroupView.centerYAnchor)
    }
    
    private func configureGoToAccountButton() {
        goToAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "person.fill", withConfiguration: configuration)
        goToAccountButton.setImage(image, for: .normal)
        
        goToAccountButton.tintColor = .darkGray
        goToAccountButton.backgroundColor = .systemGray6
        goToAccountButton.layer.cornerRadius = 40 / 2
        
        goToAccountButton.addTarget(self, action: #selector(goToAccountButtonTapped), for: .touchUpInside)
        
        goToAccountButton.setWidth(40)
        goToAccountButton.setHeight(40)
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "bonic")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        
        imageView.setWidth(UIScreen.main.bounds.width - 15)
        imageView.setHeight(UIScreen.main.bounds.width - 15)
        imageView.pinTop(to: view.topAnchor, UIScreen.main.bounds.height / 4)
        imageView.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureImageInfoView() {
        view.addSubview(imageInfoView)
        imageInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        imageInfoView.pinCenterX(to: imageView.centerXAnchor)
        imageInfoView.pinBottom(to: imageView.bottomAnchor, 5)
    }
    
    private func configureSettingsButton() {
        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: configuration)
        settingsButton.setImage(image, for: .normal)
        
        settingsButton.tintColor = .secondaryLabel
        settingsButton.backgroundColor = .systemGray6
        settingsButton.layer.cornerRadius = 35 / 2
        
        settingsButton.setWidth(35)
        settingsButton.setHeight(35)
        settingsButton.pinRight(to: detailsButton.leadingAnchor, 10)
        settingsButton.pinCenterY(to: detailsButton.centerYAnchor)
    }
    
    private func configureDetailsButton() {
        view.addSubview(detailsButton)
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        detailsButton.setTitle("View details", for: .normal)
        detailsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 9, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        detailsButton.setImage(image, for: .normal)
        
        detailsButton.tintColor = .secondaryLabel
        detailsButton.backgroundColor = .systemGray6
        detailsButton.layer.cornerRadius = 35 / 2
        
        detailsButton.semanticContentAttribute = .forceRightToLeft
        detailsButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: -7)
        
        let imageSize = image?.size ?? CGSize.zero
        let titleSize = detailsButton.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        
        detailsButton.setWidth((titleSize.width + imageSize.width) * 1.3)
        detailsButton.setHeight(35)
        detailsButton.pinBottom(to: imageView.topAnchor, 10)
        detailsButton.pinCenterX(to: imageView.centerXAnchor)
    }
    
    private func configureDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "square.and.arrow.down", withConfiguration: configuration)
        downloadButton.setImage(image, for: .normal)
        
        downloadButton.tintColor = .systemGray2
        downloadButton.backgroundColor = .systemGray6
        downloadButton.layer.cornerRadius = 45 / 2
        
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        
        downloadButton.setWidth(45)
        downloadButton.setHeight(45)
        downloadButton.pinRight(to: rewindButton.leadingAnchor, 20)
        downloadButton.pinCenterY(to: rewindButton.centerYAnchor)
    }
    
    private func configureRewindButton() {
        view.addSubview(rewindButton)
        rewindButton.translatesAutoresizingMaskIntoConstraints = false
        
        rewindButton.setTitle("Rewind", for: .normal)
        rewindButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "forward.fill", withConfiguration: configuration)
        rewindButton.setImage(image, for: .normal)
        
        rewindButton.tintColor = .customPink
        rewindButton.semanticContentAttribute = .forceRightToLeft
        rewindButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: -7)
        
        rewindButton.layer.borderColor = UIColor.customPink.cgColor
        rewindButton.layer.borderWidth = 4
        rewindButton.layer.cornerRadius = 35
        
        rewindButton.setWidth(UIScreen.main.bounds.width * 0.6)
        rewindButton.setHeight(70)
        rewindButton.pinTop(to: imageView.bottomAnchor, 10)
        rewindButton.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureFavouriteButton() {
        view.addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "heart", withConfiguration: configuration)
        favouriteButton.setImage(image, for: .normal)
        
        favouriteButton.tintColor = .systemGray2
        favouriteButton.backgroundColor = .systemGray6
        favouriteButton.layer.cornerRadius = 45 / 2
        
        favouriteButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        favouriteButton.setWidth(45)
        favouriteButton.setHeight(45)
        favouriteButton.pinLeft(to: rewindButton.trailingAnchor, 20)
        favouriteButton.pinCenterY(to: rewindButton.centerYAnchor)
    }
    
    private func configureGalleryButton() {
        view.addSubview(galleryButton)
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        
        galleryButton.setTitle("1288 objects", for: .normal)
        galleryButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.compact.down", withConfiguration: configuration)
        galleryButton.setImage(image, for: .normal)
        
        galleryButton.tintColor = .darkGray
        
        galleryButton.semanticContentAttribute = .forceRightToLeft
        
        let imageSize = image?.size ?? CGSize.zero
        let titleSize = galleryButton.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        
        galleryButton.titleEdgeInsets = UIEdgeInsets(top: -30, left: imageSize.width, bottom: 0, right: 0)
        galleryButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: -titleSize.width, bottom: -15, right: 0)
        
        galleryButton.setWidth(titleSize.width * 2)
        galleryButton.setHeight(UIScreen.main.bounds.height * 0.07)
        galleryButton.pinBottom(to: view.bottomAnchor, UIScreen.main.bounds.height / 15)
        galleryButton.pinCenterX(to: view.centerXAnchor)
    }
}