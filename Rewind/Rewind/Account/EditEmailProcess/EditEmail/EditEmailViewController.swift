//
//  EditEmailViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.02.2024.
//

import UIKit

final class EditEmailViewController: UIViewController {
    var presenter: EditEmailPresenter?
    
    private let emailLabel: UILabel = UILabel()
    private let emailField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    @objc
    private func continueButtonTapped() {
        guard let newEmail = emailField.text else { return }
        presenter?.updateEmail(with: newEmail)
    }
}

extension EditEmailViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureEmailLabel()
        configureEmailField()
        configureContinueButton()
    }
    
    private func configureEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.text = "Enter new email"
        emailLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        emailLabel.pinTop(to: view.topAnchor, 200)
        emailLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureEmailField() {
        view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.delegate = self
        
        emailField.backgroundColor = .systemBackground
        emailField.placeholder = "Email address"
        emailField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        emailField.layer.cornerRadius = 15
        emailField.returnKeyType = .done
        
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress
        
        emailField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        emailField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        emailField.leftViewMode = .always
        emailField.rightViewMode = .always
        
        emailField.setWidth(350)
        emailField.setHeight(50)
        emailField.pinTop(to: emailLabel.bottomAnchor, 30)
        emailField.pinCenterX(to: view.centerXAnchor)
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

extension EditEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
