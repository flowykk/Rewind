//
//  EnterPasswordViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class EnterPasswordViewController: UIViewController {
    var presenter: EnterPasswordPresenter?
    
    private let passwordLabel: UILabel = UILabel()
    private let passwordField: UITextField = UITextField()
    private let promtLabel: UILabel = UILabel()
//    private let forgotPasswordButton: UIButton = UIButton(type: .system)
    private let continueButton: UIButton = UIButton(type: .system)
    
    var showForgotPasswordButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        presenter?.viewDidLoad()
        configureUI()
    }
    
    // MARK: - View To Presenter
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
//    @objc
//    private func forgotPasswordButtonTapped() {
//        presenter?.forgotPasswordButtonTapped()
//    }
    
    @objc
    private func continueButtonTapped() {
        presenter?.continueButtonTapped(password: passwordField.text)
    }
    
    // MARK: - Presenter To View    
    func configureLabel(withText text: String) {
        passwordLabel.text = text
    }
    
    func configureForgotPasswordButton(withDecision decision: Bool) {
        showForgotPasswordButton = decision
    }
}

// MARK: - UITextFieldDelegate
extension EnterPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        continueButtonTapped()
        return false
    }
}

// MARK: - UI Configuration
extension EnterPasswordViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        configureBackButton()
        configurePasswordLabel()
        configurePasswordField()
//        if showForgotPasswordButton {
//            configureForgotPasswordButton()
//        }
        configurePromtLabel()
        configureContinueButton()
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .blackAdapted
    }
    
    private func configurePasswordLabel() {
        view.addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        passwordLabel.pinTop(to: view.topAnchor, AuthConsts.labelTop)
        passwordLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configurePasswordField() {
        view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField.delegate = self
        
        passwordField.backgroundColor = .systemGray6
        passwordField.placeholder = "Password"
        passwordField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        passwordField.layer.cornerRadius = 15
        passwordField.returnKeyType = .done
        passwordField.isSecureTextEntry = true
        
        passwordField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        passwordField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        passwordField.leftViewMode = .always
        passwordField.rightViewMode = .always
        
        passwordField.setHeight(50)
        passwordField.pinLeft(to: view.leadingAnchor, 20)
        passwordField.pinRight(to: view.trailingAnchor, 20)
        passwordField.pinTop(to: passwordLabel.bottomAnchor, 30)
        passwordField.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configurePromtLabel() {
        view.addSubview(promtLabel)
        promtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        promtLabel.text = "Your password must contain at least 6 characters. Only Latin letters (uppercase and lowercase) and numbers (0-9) are allowed"
        promtLabel.numberOfLines = 0
        promtLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        promtLabel.textColor = .systemGray2
        
        promtLabel.pinTop(to: passwordField.bottomAnchor, 20)
        promtLabel.pinLeft(to: passwordField.leadingAnchor, 20)
        promtLabel.pinRight(to: passwordField.trailingAnchor, 20)
    }
    
    
//    private func configureForgotPasswordButton() {
//        view.addSubview(forgotPasswordButton)
//        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        forgotPasswordButton.setTitle("forgot password?", for: .normal)
//        forgotPasswordButton.setTitleColor(UIColor(named: "customPink"), for: .normal)
//        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        
//        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
//        
//        forgotPasswordButton.pinTop(to: passwordField.bottomAnchor, 5)
//        forgotPasswordButton.pinCenterX(to: view.centerXAnchor)
//    }
    
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
