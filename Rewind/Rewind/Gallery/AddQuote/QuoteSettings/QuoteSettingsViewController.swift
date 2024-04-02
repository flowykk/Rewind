//
//  QuoteSettingsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class QuoteSettingsViewController: UIViewController {
    var presenter: QuoteSettingsPresenter?
    
    var viewDistanceTop: CGFloat = 40
    
    var addQuoteVC: AddQuoteViewController?
    
    private let quoteLabel: UILabel = UILabel()
    private let quoteField: UITextView = UITextView()
    private let authorLabel: UILabel = UILabel()
    private let authorField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
        presenter?.viewDidLoad()
        
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
        presenter?.continueButtonTapped(quoteText: quoteField.text, author: authorField.text)
    }
    
    func configureUIForSavedData(quote: String?, author: String?) {
        quoteField.text = quote
        authorField.text = author
    }
}

// MARK: - UITextFieldDelegate
extension QuoteSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if authorField.isFirstResponder {
            continueButtonTapped()
        }
        view.endEditing(true)
        return false
    }
}

// MARK: - UI Configuration
extension QuoteSettingsViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        
        configureQuoteLabel()
        configureQuoteField()
        configureAuthorLabel()
        configureAuthorField()
        configureContinueButton()
    }
    
    private func configureQuoteLabel() {
        view.addSubview(quoteLabel)
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        quoteLabel.text = "Enter quote"
        quoteLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        quoteLabel.pinTop(to: view.topAnchor, 100)
        quoteLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureQuoteField() {
        view.addSubview(quoteField)
        quoteField.translatesAutoresizingMaskIntoConstraints = false
        
        quoteField.isScrollEnabled = false
        quoteField.textContainerInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        quoteField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        quoteField.layer.cornerRadius = 20
        authorField.returnKeyType = .done
        
        quoteField.autocapitalizationType = .none
        quoteField.autocorrectionType = .no
        
        quoteField.setHeight(UIScreen.main.bounds.width / 4)
        quoteField.pinLeft(to: view.leadingAnchor, 20)
        quoteField.pinRight(to: view.trailingAnchor, 20)
        quoteField.pinTop(to: quoteLabel.bottomAnchor, 15)
        quoteField.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureAuthorLabel() {
        view.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.text = "Enter quote's author"
        authorLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        authorLabel.pinTop(to: quoteField.bottomAnchor, 30)
        authorLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureAuthorField() {
        view.addSubview(authorField)
        authorField.translatesAutoresizingMaskIntoConstraints = false
        
        authorField.delegate = self
        
        authorField.backgroundColor = .systemBackground
        authorField.placeholder = "Author (optional)"
        authorField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        authorField.layer.cornerRadius = 15
        authorField.returnKeyType = .done
        
        authorField.autocapitalizationType = .none
        authorField.autocorrectionType = .no
        
        authorField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        authorField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        authorField.leftViewMode = .always
        authorField.rightViewMode = .always
        
        authorField.setHeight(50)
        authorField.pinLeft(to: view.leadingAnchor, 20)
        authorField.pinRight(to: view.trailingAnchor, 20)
        authorField.pinTop(to: authorLabel.bottomAnchor, 15)
        authorField.pinCenterX(to: view.centerXAnchor)
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
extension QuoteSettingsViewController {
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
