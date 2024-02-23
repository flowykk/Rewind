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
    private let scrollViewContainer: UIView = UIView()
    private let avatarView: UIImageView = UIImageView()
    private var avatarImage: UIImage? = nil
    private let nameLabel: UILabel = UILabel()
    private let generalTable: UITableView = UITableView()
    private let appIconLabel: UILabel = UILabel()
    
    private let generalSections: [String] = ["Edit profile image", "Edit name", "Edit password", "Edit email", "Add a widget", "View groups", "Get help", "Share with friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        configureScrollViewContainer()
        configureAvatarView()
        configureNameLabel()
        configureGeneralTable()
//        configureAppIconLabel()
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
        scrollView.addSubview(scrollViewContainer)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.backgroundColor = .brown
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        scrollView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureScrollViewContainer() {
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        scrollViewContainer.backgroundColor = .blue
        
        scrollViewContainer.pinLeft(to: scrollView.leadingAnchor)
        scrollViewContainer.pinRight(to: scrollView.trailingAnchor)
        scrollViewContainer.pinTop(to: scrollView.topAnchor)
        scrollViewContainer.pinBottom(to: scrollView.bottomAnchor)
        scrollViewContainer.pinWidth(to: scrollView.widthAnchor)
        scrollViewContainer.pinHeight(to: scrollView.heightAnchor)
    }
    
    private func configureAvatarView() {
        scrollViewContainer.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 65
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.systemPink.cgColor
        
        avatarView.image = avatarImage
        
        avatarView.setWidth(130)
        avatarView.setHeight(130)
        avatarView.pinTop(to: scrollViewContainer.topAnchor)
        avatarView.pinCenterX(to: scrollView.centerXAnchor)
    }
    
    private func configureNameLabel() {
        scrollViewContainer.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "User name"
        
        nameLabel.pinTop(to: avatarView.bottomAnchor, 20)
        nameLabel.pinCenterX(to: scrollView.centerXAnchor)
    }
    
    private func configureGeneralTable() {
        scrollViewContainer.addSubview(generalTable)
        generalTable.translatesAutoresizingMaskIntoConstraints = false
        
        generalTable.dataSource = self
        generalTable.delegate = self
        
        generalTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        generalTable.pinTop(to: nameLabel.bottomAnchor, 20)
        generalTable.pinLeft(to: scrollViewContainer.leadingAnchor, 20)
        generalTable.pinRight(to: scrollViewContainer.trailingAnchor, 20)
        generalTable.setHeight(200)
    }
    
    private func configureAppIconLabel() {
        view.addSubview(appIconLabel)
        appIconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        appIconLabel.text = "App icon"
        
        appIconLabel.pinTop(to: generalTable.bottomAnchor, 30)
        appIconLabel.pinLeft(to: scrollViewContainer.leadingAnchor, 20)
    }
}

// MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    
}

