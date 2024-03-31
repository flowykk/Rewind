//
//  AccountViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 23.02.2024.
//

import UIKit

final class AccountViewController: UIViewController {
    var presenter: AccountPresenter?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let avatarView: UIImageView = UIImageView()
    private var avatarImage: UIImage? = nil
    private let nameLabel: UILabel = UILabel()
    private let emailLabel: UILabel = UILabel()
    private let groupsLabel: UILabel = UILabel()
    private let groupsTabel: PrimaryTableView = PrimaryTableView()
    private let generalLabel: UILabel = UILabel()
    private let generalTable: GeneralTableView = GeneralTableView()
    private let appIconLabel: UILabel = UILabel()
    private var appIconCollectionView: AppIconCollectionView = AppIconCollectionView()
    private let riskyZoneLabel: UILabel = UILabel()
    private let riskyZoneTabel: RiskyZoneTableView = RiskyZoneTableView()
    private let daysLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTabel.presenter = presenter
        generalTable.presenter = presenter
        appIconCollectionView.presenter = presenter
        riskyZoneTabel.presenter = presenter
        presenter?.collectionView = appIconCollectionView
        configureUI()
        presenter?.viewDidLoad()
    }
    
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    func setUserImage(to image: UIImage) {
        avatarView.image = image
    }
    
    func setUserName(to name: String) {
        nameLabel.text = name
    }
    
    func setUserEmail(to email: String) {
        emailLabel.text = email
    }
    
    func setDaysWithRewind(to days: Int) {
        daysLabel.text = "You are already \(days) days with Rewind"
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AccountViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            presenter?.newImageSelected(originalImage: selectedImage)
        }
        dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension AccountViewController: UINavigationControllerDelegate { }

// MARK: - UI Configuration
extension AccountViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureScrollView()
        configureContentView()
        configureAvatarView()
        configureNameLabel()
        configureEmailLabel()
        configureGroupsLabel()
        configureGroupsTable()
        configureGeneralLabel()
        configureGeneralTable()
        configureAppIconLabel()
        configureAppIconCollectionView()
        configureRiskyZoneLabel()
        configureRiskyZoneTabel()
        configureDaysLabel()
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
        contentView.setHeight(1040)
    }
    
    private func configureAvatarView() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        
        let width = UIScreen.main.bounds.width / 3
        
        avatarView.layer.cornerRadius = width / 2
        
        avatarView.setWidth(width)
        avatarView.setHeight(width)
        avatarView.pinTop(to: contentView.topAnchor)
        avatarView.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        nameLabel.pinTop(to: avatarView.bottomAnchor, 10)
        nameLabel.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureEmailLabel() {
        contentView.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emailLabel.textColor = .systemGray3
        
        emailLabel.pinTop(to: nameLabel.bottomAnchor, 5)
        emailLabel.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureGroupsLabel() {
        contentView.addSubview(groupsLabel)
        groupsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupsLabel.text = "Groups"
        groupsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        groupsLabel.pinTop(to: emailLabel.bottomAnchor, 30)
        groupsLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureGroupsTable() {
        contentView.addSubview(groupsTabel)
        groupsTabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupsTabel.pinTop(to: groupsLabel.bottomAnchor, 10)
        groupsTabel.pinLeft(to: contentView.leadingAnchor, 20)
        groupsTabel.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureGeneralLabel() {
        contentView.addSubview(generalLabel)
        generalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        generalLabel.text = "General"
        generalLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        generalLabel.pinTop(to: groupsTabel.bottomAnchor, 25)
        generalLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureGeneralTable() {
        contentView.addSubview(generalTable)
        generalTable.translatesAutoresizingMaskIntoConstraints = false
        
        generalTable.pinTop(to: generalLabel.bottomAnchor, 10)
        generalTable.pinLeft(to: contentView.leadingAnchor, 20)
        generalTable.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureAppIconLabel() {
        contentView.addSubview(appIconLabel)
        appIconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        appIconLabel.text = "App icon"
        appIconLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        appIconLabel.pinTop(to: generalTable.bottomAnchor, 25)
        appIconLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureAppIconCollectionView() {
        contentView.addSubview(appIconCollectionView)
        appIconCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        appIconCollectionView.pinLeft(to: contentView.leadingAnchor, 20)
        appIconCollectionView.pinRight(to: contentView.trailingAnchor, 20)
        appIconCollectionView.pinTop(to: appIconLabel.bottomAnchor, 10)
    }
    
    private func configureRiskyZoneLabel() {
        contentView.addSubview(riskyZoneLabel)
        riskyZoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        riskyZoneLabel.text = "Risky zone"
        riskyZoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        riskyZoneLabel.pinTop(to: appIconCollectionView.bottomAnchor, 25)
        riskyZoneLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureRiskyZoneTabel() {
        contentView.addSubview(riskyZoneTabel)
        riskyZoneTabel.translatesAutoresizingMaskIntoConstraints = false
        
        riskyZoneTabel.pinTop(to: riskyZoneLabel.bottomAnchor, 10)
        riskyZoneTabel.pinLeft(to: contentView.leadingAnchor, 20)
        riskyZoneTabel.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureDaysLabel() {
        contentView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        daysLabel.textColor = .systemGray4
        
        daysLabel.pinTop(to: riskyZoneTabel.bottomAnchor, 30)
        daysLabel.pinCenterX(to: contentView.centerXAnchor)
    }
}
