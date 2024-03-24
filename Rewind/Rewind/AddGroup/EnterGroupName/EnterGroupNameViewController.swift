//
//  EnterGroupNameViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class EnterGroupNameViewController: UIViewController {
    var presenter: EnterGroupNamePresenter?
    
    var allGroupsVCDelegate: AllGroupsViewController?
    
    private let groupNameLabel: UILabel = UILabel()
    private let groupNameField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    @objc
    private func continueButtonTapped() {
        guard let groupName = groupNameField.text else { return }
        presenter?.continueButtonTapped(groupName: groupName)
    }
}

extension EnterGroupNameViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureGroupNameLabel()
        configureGroupNameField()
        configureContinueButton()
    }
    
    private func configureGroupNameLabel() {
        view.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel.text = "Enter group's name"
        groupNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        groupNameLabel.pinTop(to: view.topAnchor, 200)
        groupNameLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureGroupNameField() {
        view.addSubview(groupNameField)
        groupNameField.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameField.backgroundColor = .systemBackground
        groupNameField.placeholder = "Group's name"
        groupNameField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        groupNameField.layer.cornerRadius = 15
        groupNameField.returnKeyType = .done
        
        groupNameField.autocapitalizationType = .none
        groupNameField.autocorrectionType = .no
        
        groupNameField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        groupNameField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        groupNameField.leftViewMode = .always
        groupNameField.rightViewMode = .always
        
        groupNameField.setHeight(50)
        groupNameField.pinLeft(to: view.leadingAnchor, 20)
        groupNameField.pinRight(to: view.trailingAnchor, 20)
        groupNameField.pinTop(to: groupNameLabel.bottomAnchor, 30)
        groupNameField.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureContinueButton() {
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(UIColor(named: "customPink"), for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        continueButton.layer.borderColor = UIColor(named: "customPink")?.cgColor
        continueButton.layer.borderWidth = 4
        continueButton.layer.cornerRadius = 30
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        continueButton.pinBottom(to: view.bottomAnchor, 150)
        continueButton.pinCenterX(to: view.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}
