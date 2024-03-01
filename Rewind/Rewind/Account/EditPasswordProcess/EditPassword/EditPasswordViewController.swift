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
    
    private let viewDistanceTop: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        view.frame.size.height = UIScreen.main.bounds.height - viewDistanceTop
        view.frame.origin.y = viewDistanceTop
        view.layer.cornerRadius = 20
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

// MARK: - Private funcs
extension EditPasswordViewController {
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            break
        case .changed:
            let translation = gesture.translation(in: view)
            if view.frame.origin.y + translation.y >= viewDistanceTop {
                view.frame.origin.y += translation.y
                gesture.setTranslation(.zero, in: view)
            }
        case .ended:
            let velocity = gesture.velocity(in: view)
            let childViewHeight = UIScreen.main.bounds.height - viewDistanceTop
            if velocity.y > 0 && view.frame.origin.y > childViewHeight * 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y = UIScreen.main.bounds.height
                }) { _ in
                    self.dismiss(animated: true) {
                        self.enterAuthCodeVC?.dismiss(animated: true)
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y = self.viewDistanceTop
                }) { _ in
                    self.view.frame.origin.y = self.viewDistanceTop
                }
            }
        default:
            break
        }
    }
}

