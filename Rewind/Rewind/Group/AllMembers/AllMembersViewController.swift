//
//  AllMembersViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class AllMembersViewController: UIViewController {
    var presenter: AllMembersPresenter?
    
    var contentViewHeightConstraint: NSLayoutConstraint?
    var membersTableHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let searchField: UITextField = UITextField()
    private let membersTable: MembersTableView = MembersTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.hideKeyboardWhenTappedAround()
        presenter?.membersTable = membersTable
        membersTable.presenter = presenter
        configureNavigationTitle()
        configureUI()
        presenter?.getGroupMembers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewsHeight()
    }
    
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        membersTableHeightConstraint?.isActive = false
        
        var membersTableHeight = membersTable.contentSize.height
        
        if membersTableHeight > 0 {
            membersTableHeight -= 1
        }
        
        var contentViewHeight = 60 + membersTableHeight + 30
        
        if contentViewHeight < view.frame.size.height {
            contentViewHeight = view.frame.size.height
        }
        
        membersTableHeightConstraint = membersTable.heightAnchor.constraint(equalToConstant: membersTableHeight)
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        
        membersTableHeightConstraint?.isActive = true
        contentViewHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
    
    func configureNavigationTitle() {
        if let currentGroup = DataManager.shared.getCurrentGroup() {
            navigationItem.title = currentGroup.name
        } else {
            navigationItem.title = "Group name"
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension AllMembersViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            if toVC is GroupViewController {
                return PopToBottomTransitioning()
            }
        default:
            return nil
        }
        return nil
    }
}

// MARK: - UI Configuration
extension AllMembersViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureScrollView()
        configureContentView()
        configureSearchField()
        configureMembersTable()
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
    
    private func configureSearchField() {
        contentView.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        searchField.placeholder = "Member's name"
        searchField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let imageWidth = UIScreen.main.bounds.width * 0.09
        let leftViewWidth = 12 + imageWidth + 12
        
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        image = image?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        imageView.image = image
        
        imageView.setWidth(leftViewWidth)
        imageView.setHeight(50)
        
        searchField.leftView = imageView
        searchField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        searchField.leftViewMode = .always
        searchField.rightViewMode = .always
        searchField.backgroundColor = .systemGray6
        searchField.layer.cornerRadius = 20
        
        searchField.setHeight(50)
        searchField.pinTop(to: contentView.topAnchor, 0)
        searchField.pinLeft(to: contentView.leadingAnchor, 20)
        searchField.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureMembersTable() {
        contentView.addSubview(membersTable)
        membersTable.translatesAutoresizingMaskIntoConstraints = false
        
        membersTable.isAllMembersButtonShown = false
        membersTable.isScrollEnabled = false
        
        membersTable.pinTop(to: searchField.bottomAnchor, 10)
        membersTable.pinLeft(to: contentView.leadingAnchor, 20)
        membersTable.pinRight(to: contentView.trailingAnchor, 20)
    }
}
