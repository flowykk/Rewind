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
    private let generalLabel: UILabel = UILabel()
    private let generalTable: UITableView = GeneralTableView()
    private let appIconLabel: UILabel = UILabel()
    private var appIconCollectionView: AppIconCollectionView = AppIconCollectionView()
    private let riskyZoneLabel: UILabel = UILabel()
    private let riskyZoneTabel: UITableView = RiskyZoneTableView()
    private let daysLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appIconCollectionView.presenter = presenter
        presenter?.collectionView = appIconCollectionView
        presenter?.viewDidLoad()
        configureUI()
    }
    
    // MARK: - View To Presenter
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    // MARK: - Presenter To View
    func setAvatarImage(image: UIImage) {
        avatarImage = image
    }
}

// MARK: - UI Configuration
extension AccountViewController {
    private func configureUI() {
        view.backgroundColor = .white
        configureBackButton()
        configureScrollView()
        configureContentView()
        configureAvatarView()
        configureNameLabel()
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
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinTop(to: view.topAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .white
        
        contentView.pinLeft(to: scrollView.leadingAnchor)
        contentView.pinRight(to: scrollView.trailingAnchor)
        contentView.pinTop(to: scrollView.topAnchor)
        contentView.pinBottom(to: scrollView.bottomAnchor)
        contentView.pinWidth(to: scrollView.widthAnchor)
        contentView.setHeight(1015)
    }
    
    private func configureAvatarView() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 65
        avatarView.layer.borderWidth = 4
        avatarView.layer.borderColor = UIColor.systemPink.cgColor
        
        avatarView.image = avatarImage
        
        avatarView.setWidth(130)
        avatarView.setHeight(130)
        avatarView.pinTop(to: contentView.topAnchor)
        avatarView.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "User name"
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        nameLabel.pinTop(to: avatarView.bottomAnchor, 10)
        nameLabel.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureGeneralLabel() {
        contentView.addSubview(generalLabel)
        generalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        generalLabel.text = "General"
        generalLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        generalLabel.pinTop(to: nameLabel.bottomAnchor, 30)
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
        
        appIconLabel.pinTop(to: generalTable.bottomAnchor, 30)
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
        
        riskyZoneLabel.pinTop(to: appIconCollectionView.bottomAnchor, 30)
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
        
        daysLabel.text = "You are already N days with Rewind"
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        daysLabel.textColor = .systemGray4
        
        daysLabel.pinTop(to: riskyZoneTabel.bottomAnchor, 30)
        daysLabel.pinCenterX(to: contentView.centerXAnchor)
    }
}
