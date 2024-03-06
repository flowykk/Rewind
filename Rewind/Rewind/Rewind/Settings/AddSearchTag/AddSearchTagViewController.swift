//
//  AddSearchTagViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class AddSearchTagViewController: UIViewController {
    var presenter: AddSearchTagPresenter?
    weak var delegate: SettingsViewController?
    
    private let titleLabel: UILabel = UILabel()
    private let tagField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    @objc
    private func continueButtonTapped() {
        if let newTag = tagField.text {
            if !newTag.isEmpty {
                presenter?.addTag(withTitle: newTag)
            }
        }
    }
}

extension AddSearchTagViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureTitleLabel()
        configureTagField()
        configureContinueButton()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Enter new tag"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        titleLabel.pinTop(to: view.topAnchor, 150)
        titleLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureTagField() {
        view.addSubview(tagField)
        tagField.translatesAutoresizingMaskIntoConstraints = false
        
        tagField.delegate = self
        
        tagField.backgroundColor = .systemGray6
        tagField.placeholder = "Your tag"
        tagField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        tagField.layer.cornerRadius = 15
        tagField.returnKeyType = .done
        
        tagField.autocapitalizationType = .none
        tagField.autocorrectionType = .no
        
        tagField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        tagField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        tagField.leftViewMode = .always
        tagField.rightViewMode = .always
        
        tagField.setHeight(50)
        tagField.pinLeft(to: view.leadingAnchor, 20)
        tagField.pinRight(to: view.trailingAnchor, 20)
        tagField.pinTop(to: titleLabel.bottomAnchor, 30)
        tagField.pinCenterX(to: view.centerXAnchor)
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

extension AddSearchTagViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
