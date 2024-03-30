//
//  EnterNameViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class EnterNameViewController: UIViewController {
    var presenter: EnterNamePresenter?
    
    private let nameLabel: UILabel = UILabel()
    private let nameField: UITextField = UITextField()
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
        presenter?.saveName(name: nameField.text)
    }
}

// MARK: - UITextFieldDelegate
extension EnterNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        continueButtonTapped()
        return false
    }
}

// MARK: - UI Configuration
extension EnterNameViewController {
    private func configureUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureNameLabel()
        configureNameField()
        configureContinueButton()
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "What's your name?"
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        nameLabel.pinTop(to: view.topAnchor, AuthConsts.labelTop)
        nameLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureNameField() {
        view.addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        nameField.delegate = self
        
        nameField.backgroundColor = .systemGray6
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
        
        continueButton.pinBottom(to: view.bottomAnchor, AuthConsts.continueButtonBottom)
        continueButton.pinCenterX(to: view.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}
