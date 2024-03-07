//
//  GroupSettingsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupSettingsViewController: UIViewController {
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let groupImageView: UIImageView = UIImageView()
    private let groupNameLabel: UILabel = UILabel()
    private let groupGeneralLabel: UILabel = UILabel()
    private let groupGeneralTable: GroupGeneralTableView = GroupGeneralTableView()
    private let groupRiskyZoneLabel: UILabel = UILabel()
    private let groupRiskyZoneTable: GroupRiskyZoneTableView = GroupRiskyZoneTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewsHeight()
    }
    
    @objc
    private func backButtonTapped() {
        print("go back")
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        
        let contentViewHeight = view.frame.height
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        
        contentViewHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
}

extension GroupSettingsViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureScrollView()
        configureContentView()
        configureGroupImageView()
        configureGroupNameLabel()
        configureGroupGeneralLabel()
        configureGroupGeneralTabel()
        configureGroupRiskyZoneLabel()
        configureGroupRiskyZoneTabel()
    }
    
    private func configureBackButton() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
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
    
    private func configureGroupImageView() {
        contentView.addSubview(groupImageView)
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageView.image = UIImage(named: "groupImage")
        
        groupImageView.contentMode = .scaleAspectFill
        groupImageView.clipsToBounds = true
        
        let width = UIScreen.main.bounds.width / 3
        
        groupImageView.layer.cornerRadius = width / 2
        
        groupImageView.setWidth(width)
        groupImageView.setHeight(width)
        groupImageView.pinTop(to: contentView.topAnchor)
        groupImageView.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureGroupNameLabel() {
        contentView.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel.text = "Group name"
        groupNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        groupNameLabel.pinTop(to: groupImageView.bottomAnchor, 10)
        groupNameLabel.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureGroupGeneralLabel() {
        contentView.addSubview(groupGeneralLabel)
        groupGeneralLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupGeneralLabel.text = "General"
        groupGeneralLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        groupGeneralLabel.pinTop(to: groupNameLabel.bottomAnchor, 25)
        groupGeneralLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureGroupGeneralTabel() {
        contentView.addSubview(groupGeneralTable)
        groupGeneralTable.translatesAutoresizingMaskIntoConstraints = false
        
        groupGeneralTable.pinTop(to: groupGeneralLabel.bottomAnchor, 10)
        groupGeneralTable.pinLeft(to: contentView.leadingAnchor, 20)
        groupGeneralTable.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureGroupRiskyZoneLabel() {
        contentView.addSubview(groupRiskyZoneLabel)
        groupRiskyZoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupRiskyZoneLabel.text = "Risky zone"
        groupRiskyZoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        groupRiskyZoneLabel.pinTop(to: groupGeneralTable.bottomAnchor, 25)
        groupRiskyZoneLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureGroupRiskyZoneTabel() {
        contentView.addSubview(groupRiskyZoneTable)
        groupRiskyZoneTable.translatesAutoresizingMaskIntoConstraints = false
        
        groupRiskyZoneTable.pinTop(to: groupRiskyZoneLabel.bottomAnchor, 10)
        groupRiskyZoneTable.pinLeft(to: contentView.leadingAnchor, 20)
        groupRiskyZoneTable.pinRight(to: contentView.trailingAnchor, 20)
    }
}
