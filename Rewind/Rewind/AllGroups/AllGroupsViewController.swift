//
//  AllGroupsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class AllGroupsViewController: UIViewController {
    var presenter: AllGroupsPresenter?
    
    var contentViewHeightConstraint: NSLayoutConstraint?
    var groupsTableHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let searchField: UITextField = UITextField()
    private let groupsTable: GroupsTableView = GroupsTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        groupsTable.presenter = presenter
        presenter?.groupsTable = groupsTable
        configureUI()
        presenter?.getUserGroups()
        print("AllGroupsVC Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AllGroupsVC Will Appear")
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
    private func searchTextChanged() {
        presenter?.searchTextChanged(newValue: searchField.text)
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        groupsTableHeightConstraint?.isActive = false
        
        var groupsTableHeight = groupsTable.contentSize.height
        
        if groupsTableHeight > 0 {
            groupsTableHeight -= 1
        }
        
        var contentViewHeight = 60 + groupsTableHeight + 20
        
        if contentViewHeight < view.frame.size.height {
            contentViewHeight = view.frame.size.height
        }
        
        groupsTableHeightConstraint = groupsTable.heightAnchor.constraint(equalToConstant: groupsTableHeight)
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        
        groupsTableHeightConstraint?.isActive = true
        contentViewHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
}

// MARK: - UITextFieldDelegate
extension AllGroupsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

// MARK: - UI Configuration
extension AllGroupsViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureScrollView()
        configureContentView()
        configureSearchField()
        configureGroupsTable()
    }
    
    private func configureBackButton() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
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
    }
    
    private func configureSearchField() {
        contentView.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        searchField.placeholder = "Group's name"
        searchField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        searchField.delegate = self
        
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
        
        searchField.addTarget(self, action: #selector(searchTextChanged), for: .allEditingEvents)
        
        searchField.setHeight(50)
        searchField.pinTop(to: contentView.topAnchor, 0)
        searchField.pinLeft(to: contentView.leadingAnchor, 20)
        searchField.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureGroupsTable() {
        contentView.addSubview(groupsTable)
        groupsTable.translatesAutoresizingMaskIntoConstraints = false
        
        groupsTable.isScrollEnabled = false
        
        groupsTable.pinTop(to: searchField.bottomAnchor, 10)
        groupsTable.pinLeft(to: contentView.leadingAnchor, 20)
        groupsTable.pinRight(to: contentView.trailingAnchor, 20)
    }
}
