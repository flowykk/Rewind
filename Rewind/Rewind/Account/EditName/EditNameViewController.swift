//
//  EditNameViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import UIKit

final class EditNameViewController: UIViewController {
    var presenter: EditNamePresenter?
    
    private let nameLabel: UILabel = UILabel()
    private let nameField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    @objc
    private func continueButtonTapped() {
        guard let newName = nameField.text else { return }
        presenter?.updateName(with: newName)
    }
}

// MARK: - UI Configuration
extension EditNameViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureNameLabel()
        configureNameField()
        configureContinueButton()
    }
    
    private func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Enter new name"
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        nameLabel.pinTop(to: view.topAnchor, 200)
        nameLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureNameField() {
        view.addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        nameField.delegate = self
        
        nameField.backgroundColor = .systemBackground
        nameField.placeholder = "Name"
        nameField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameField.layer.cornerRadius = 15
        nameField.returnKeyType = .done
        
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        
        nameField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        nameField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        nameField.leftViewMode = .always
        nameField.rightViewMode = .always
        
        nameField.setWidth(350)
        nameField.setHeight(50)
        nameField.pinTop(to: nameLabel.bottomAnchor, 30)
        nameField.pinCenterX(to: view.centerXAnchor)
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

extension EditNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
