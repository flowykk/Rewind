//
//  EnterEmailViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class EnterEmailViewController: UIViewController {
    var presenter: EnterEmailPresenter?
    
    private let emailLabel: UILabel = UILabel()
    private let emailField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    // MARK: - View To Presenter
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    @objc
    private func continueButtonTapped() {
        presenter?.continueButtonTapped(email: emailField.text)
    }
}

// MARK: - UITextFieldDelegate
extension EnterEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        continueButtonTapped()
        return false
    }
}

// MARK: - UI Configuration
extension EnterEmailViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureEmailLabel()
        configureEmailField()
        configureContinueButton()
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .blackAdapted
    }
    
    private func configureEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.text = "What's your email?"
        emailLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        emailLabel.pinTop(to: view.topAnchor, AuthConsts.labelTop)
        emailLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureEmailField() {
        view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.delegate = self
        
        emailField.backgroundColor = .systemGray6
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
        
        emailField.setHeight(50)
        emailField.pinLeft(to: view.leadingAnchor, 20)
        emailField.pinRight(to: view.trailingAnchor, 20)
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
        
        continueButton.pinBottom(to: view.bottomAnchor, AuthConsts.continueButtonBottom)
        continueButton.pinCenterX(to: view.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}
