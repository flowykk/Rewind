//
//  GroupSettingsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupSettingsViewController: UIViewController {
    var presenter: GroupSettingsPresenter?
    
    var contentViewHeightConstraint: NSLayoutConstraint?
    var groupRiskyZoneTableHeightConstraint: NSLayoutConstraint?
    
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
        navigationController?.delegate = self
        groupGeneralTable.presenter = presenter
        groupRiskyZoneTable.presenter = presenter
        configureData()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        updateViewsHeight()
    }
    
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        groupRiskyZoneTableHeightConstraint?.isActive = false
        
        var groupRiskyZoneTableHeight = groupRiskyZoneTable.contentSize.height
        
        if groupRiskyZoneTableHeight > 0 {
            groupRiskyZoneTableHeight -= 1
        }
        
        let contentViewHeight = view.frame.height
        
        groupRiskyZoneTableHeightConstraint = groupRiskyZoneTable.heightAnchor.constraint(greaterThanOrEqualToConstant: groupRiskyZoneTableHeight)
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        
        groupRiskyZoneTableHeightConstraint?.isActive = true
        contentViewHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
    
    func configureData() {
        let currentGroup = DataManager.shared.getCurrentGroup()
        
        if let bigImage = currentGroup?.bigImage {
            groupImageView.image = bigImage
        } else {
            guard let defaultImage = UIImage(named: "groupImage") else { return }
            groupImageView.image = defaultImage
        }
        
        groupNameLabel.text = currentGroup?.name
    }
    
    func setGroupName(_ name: String) {
        groupNameLabel.text = name
    }
    
    func setGroupImage(to imageData: Data) {
        groupImageView.image = UIImage(data: imageData)
    }
}

// MARK: - UINavigationControllerDelegate
extension GroupSettingsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            if toVC is GroupViewController {
                return PopTransitioning()
            }
        default:
            return nil
        }
        return nil
    }
}

// MARK: - UIImagePickerControllerDelegate
extension GroupSettingsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            presenter?.newImageSelected(originalImage: selectedImage)
        }
        dismiss(animated: true)
    }
}

// MARK: - UI Configuration
extension GroupSettingsViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
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
