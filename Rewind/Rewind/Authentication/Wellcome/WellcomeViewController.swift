//
//  WellcomeViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class WellcomeViewController: UIViewController {
    var presenter: WellcomePresenter?
    
    private let appName: UILabel = UILabel()
    private let registerButton: UIButton = UIButton(type: .system)
    private let loginButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - View To Presenter
    @objc
    private func registerButtonTapped() {
        presenter?.registerButtonTapped()
    }
    
    @objc
    private func loginButtonTapped() {
        presenter?.loginButtonTapped()
    }
}

// MARK: - UI Configuration
extension WellcomeViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureAppName()
        configureLoginButton()
        configureRegisterButton()
    }
    
    private func configureAppName() {
        view.addSubview(appName)
        appName.translatesAutoresizingMaskIntoConstraints = false
        
        appName.text = "Rewind"
        appName.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
        
        appName.pinTop(to: view.topAnchor, AuthConsts.appNameTop)
        appName.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureRegisterButton() {
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        registerButton.setTitle("Create an account", for: .normal)
        registerButton.setTitleColor(UIColor(named: "customPink"), for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        registerButton.layer.borderColor = UIColor(named: "customPink")?.cgColor
        registerButton.layer.borderWidth = 4
        registerButton.layer.cornerRadius = 30
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        registerButton.pinBottom(to: loginButton.topAnchor, AuthConsts.registerButtonBottom)
        registerButton.pinCenterX(to: view.centerXAnchor)
        registerButton.setHeight(60)
        registerButton.setWidth(230)
    }
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.setTitle("Sign in", for: .normal)
        loginButton.setTitleColor(UIColor(named: "customPink"), for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        loginButton.pinBottom(to: view.bottomAnchor, AuthConsts.loginButtonBottom)
        loginButton.pinCenterX(to: view.centerXAnchor)
        loginButton.setHeight(25)
        loginButton.setWidth(70)
    }
}
