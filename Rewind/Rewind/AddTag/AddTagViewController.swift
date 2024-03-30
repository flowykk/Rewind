//
//  AddTagViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class AddTagViewController: UIViewController {
    var presenter: AddTagPresenter?
    
    var viewDistanceTop: CGFloat = 40
    
    var detailsVC: DetailsViewController?
    var addPhotoVC: AddPhotoViewController?
    var addQuoteVC: AddQuoteViewController?
    
    var existingTags: [Tag]?
    var mediaId: Int?
    
    private let titleLabel: UILabel = UILabel()
    private let tagField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
    
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
        presenter?.continueButtonTapped(tagText: tagField.text)
    }
}

// MARK: - UI Configuration
extension AddTagViewController {
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
        
        tagField.backgroundColor = .systemBackground
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

// MARK: - UITextFieldDelegate
extension AddTagViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

// MARK: - Private funcs
extension AddTagViewController {
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
