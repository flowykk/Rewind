//
//  EditPasswordViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import UIKit

final class EditPasswordViewController: UIViewController {
    var presenter: EditPasswordPresenter?
    
    weak var enterAuthCodeVC: UIViewController?
    
    private let passwordLabel: UILabel = UILabel()
    private let passwordField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    @objc
    private func continueButtonTapped() {
        guard let newPassword = passwordField.text else { return }
        presenter?.updatePassword(with: newPassword)
    }
}

// MARK: - UI Configuration
extension EditPasswordViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configurePasswordLabel()
        configurePasswordField()
        configureContinueButton()
    }
    
    private func configurePasswordLabel() {
        view.addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordLabel.text = "Enter new password"
        passwordLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        passwordLabel.pinTop(to: view.topAnchor, 200)
        passwordLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configurePasswordField() {
        view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField.delegate = self
        
        passwordField.backgroundColor = .systemBackground
        passwordField.placeholder = "Password"
        passwordField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        passwordField.layer.cornerRadius = 15
        passwordField.returnKeyType = .done
        passwordField.isSecureTextEntry = true
        
        passwordField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        passwordField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        passwordField.leftViewMode = .always
        passwordField.rightViewMode = .always
        
        passwordField.setWidth(350)
        passwordField.setHeight(50)
        passwordField.pinTop(to: passwordLabel.bottomAnchor, 30)
        passwordField.pinCenterX(to: view.centerXAnchor)
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

// MARK: - UITextFieldDelegate
extension EditPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

