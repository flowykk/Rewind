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
    private let forgotPasswordButton: UIButton = UIButton(type: .system)
    private let continueButton: UIButton = UIButton(type: .system)
    
    private let blueMonsterImageView: UIImageView = UIImageView()
    
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
    
    @objc
    private func continueButtonTapped() {
        guard let password = passwordField.text else { return }
        presenter?.continueButtonTapped(password: password)
    }
    
    // MARK: - Presenter To View
    func showLoadingView() {
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(loadingView)
        loadingView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = false
    }
    
    func hideLoadingView() {
        view.subviews.first(where: { $0.backgroundColor == UIColor(white: 0, alpha: 0.3) })?.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    func configureLabel(withText text: String) {
        passwordLabel.text = text
    }
    
    func configureForgotPasswordButton(withDecision decision: Bool) {
        showForgotPasswordButton = decision
    }
}

// MARK: - UI Configuration
extension EnterPasswordViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        configureBackButton()
        configurePasswordLabel()
        configurePasswordField()
        if showForgotPasswordButton {
            configureForgotPasswordButton()
        }
        configureContinueButton()
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
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
        
        passwordField.setWidth(350)
        passwordField.setHeight(50)
        passwordField.pinTop(to: passwordLabel.bottomAnchor, 30)
        passwordField.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureForgotPasswordButton() {
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        forgotPasswordButton.setTitle("forgot password?", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor(named: "customPink"), for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        forgotPasswordButton.addTarget(self, action: #selector(showBlueMonster), for: .touchUpInside)
        
        forgotPasswordButton.pinTop(to: passwordField.bottomAnchor, 5)
        forgotPasswordButton.pinCenterX(to: view.centerXAnchor)
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
    
    private func configureBlueMonsterImageView() {
        view.addSubview(blueMonsterImageView)
        blueMonsterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        blueMonsterImageView.image = UIImage(named: "blueMonster")
        blueMonsterImageView.layer.cornerRadius = 20
        
        blueMonsterImageView.pinCenter(to: continueButton)
        blueMonsterImageView.setHeight(300)
        blueMonsterImageView.setWidth(300)
    }
    
    @objc
    private func showBlueMonster() {
        configureBlueMonsterImageView()
        continueButton.isEnabled = false
    }
}

// MARK: - UITextFieldDelegate
extension EnterPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
