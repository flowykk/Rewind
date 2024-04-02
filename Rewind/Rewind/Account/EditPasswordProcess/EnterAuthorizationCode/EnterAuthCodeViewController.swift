//
//  EnterAuthCodeViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import UIKit

final class EnterAuthCodeViewController: UIViewController {
    var presenter: EnterAuthCodePresenter?
    
    private let codeLabel: UILabel = UILabel()
    private var digit1Field: UITextField = UITextField()
    private var digit2Field: UITextField = UITextField()
    private var digit3Field: UITextField = UITextField()
    private var digit4Field: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    var viewDistanceTop: CGFloat = 40
    
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
        let digits = [digit1Field, digit2Field, digit3Field, digit4Field]
        let code = digits.compactMap { $0.text }.joined()
        presenter?.validateCode(code)
    }
}

// MARK: - UITextFieldDelegate
extension EnterAuthCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let character = string.first, character.isNumber {
            if textField == digit1Field {
                digit2Field.becomeFirstResponder()
                textField.text = string
            } else if textField == digit2Field {
                digit3Field.becomeFirstResponder()
                textField.text = string
            } else if textField == digit3Field {
                digit4Field.becomeFirstResponder()
                textField.text = string
            } else if textField == digit4Field {
                textField.text = string
                continueButtonTapped()
            }
            return false
        }
        
        return true
    }
}

// MARK: - UI Configuration
extension EnterAuthCodeViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureCodeLabel()
        configureDigitsStack()
        configureContinueButton()
    }
    
    private func configureCodeLabel() {
        view.addSubview(codeLabel)
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        codeLabel.text = "Enter verification code"
        codeLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        codeLabel.pinTop(to: view.topAnchor, 200)
        codeLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureDigitsStack() {
        let stackView: UIStackView = UIStackView()
        view.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        digit1Field = createDigitField()
        digit2Field = createDigitField()
        digit3Field = createDigitField()
        digit4Field = createDigitField()
        
        for subView in [digit1Field, digit2Field, digit3Field, digit4Field] {
            stackView.addArrangedSubview(subView)
        }
        
        stackView.pinCenterX(to: view.centerXAnchor)
        stackView.pinTop(to: codeLabel.bottomAnchor, 30)
    }
    
    private func createDigitField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 15
        textField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        
        textField.setWidth(60)
        textField.setHeight(70)
        return textField
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

// MARK: - Private funcs
extension EnterAuthCodeViewController {
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
                    self.dismiss(animated: false, completion: nil)
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
