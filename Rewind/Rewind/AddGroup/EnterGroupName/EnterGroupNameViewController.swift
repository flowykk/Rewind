//
//  EnterGroupNameViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class EnterGroupNameViewController: UIViewController {
    var presenter: EnterGroupNamePresenter?
    
    weak var allGroupsVCDelegate: AllGroupsViewController?
    var viewDistanceTop: CGFloat = 40
    
    private let groupNameLabel: UILabel = UILabel()
    private let groupNameField: UITextField = UITextField()
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
        guard let groupName = groupNameField.text else { return }
        presenter?.continueButtonTapped(groupName: groupName)
    }
}

// MARK: - UI Configuration
extension EnterGroupNameViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureGroupNameLabel()
        configureGroupNameField()
        configureContinueButton()
    }
    
    private func configureGroupNameLabel() {
        view.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel.text = "Enter group's name"
        groupNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        groupNameLabel.pinTop(to: view.topAnchor, 200)
        groupNameLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureGroupNameField() {
        view.addSubview(groupNameField)
        groupNameField.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameField.backgroundColor = .systemBackground
        groupNameField.placeholder = "Group's name"
        groupNameField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        groupNameField.layer.cornerRadius = 15
        groupNameField.returnKeyType = .done
        
        groupNameField.autocapitalizationType = .none
        groupNameField.autocorrectionType = .no
        
        groupNameField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        groupNameField.rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: 20, height: 50))
        groupNameField.leftViewMode = .always
        groupNameField.rightViewMode = .always
        
        groupNameField.setHeight(50)
        groupNameField.pinLeft(to: view.leadingAnchor, 20)
        groupNameField.pinRight(to: view.trailingAnchor, 20)
        groupNameField.pinTop(to: groupNameLabel.bottomAnchor, 30)
        groupNameField.pinCenterX(to: view.centerXAnchor)
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
extension EnterGroupNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

// MARK: - Private funcs
extension EnterGroupNameViewController {
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
