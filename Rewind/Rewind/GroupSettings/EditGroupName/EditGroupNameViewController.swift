//
//  EditGroupNameViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import UIKit

final class EditGroupNameViewController: UIViewController {
    var presenter: EditGroupNamePresenter?
    weak var groupSettingVC: GroupSettingsViewController?
    
    private let nameLabel: UILabel = UILabel()
    private let nameField: UITextField = UITextField()
    private let continueButton: UIButton = UIButton(type: .system)
   
    var viewDistanceTop: CGFloat = 40
    
    var onNameUpdated: ((String) -> Void)?
    
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
        guard let newName = nameField.text else { return }
        presenter?.updateName(to: newName)
    }
}

// MARK: - UI Configuration
extension EditGroupNameViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureNameLabel()
        configureNameField()
        configureContinueButton()
    }
    
    private func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Enter new name"
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        nameLabel.pinTop(to: view.topAnchor, 200)
        nameLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureNameField() {
        view.addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        nameField.delegate = self
        
        nameField.backgroundColor = .systemBackground
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
        
        continueButton.pinBottom(to: view.bottomAnchor, 150)
        continueButton.pinCenterX(to: view.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}

// MARK: - UITextFieldDelegate
extension EditGroupNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

// MARK: - Private funcs
extension EditGroupNameViewController {
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
