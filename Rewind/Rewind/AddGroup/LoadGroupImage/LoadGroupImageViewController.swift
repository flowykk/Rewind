//
//  LoadGroupImageViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class LoadGroupImageViewController: UIViewController {
    var presenter: LoadGroupImagePresenter?
    weak var enterGroupNameVC: UIViewController?
    
    private let groupImageLabel: UILabel = UILabel()
    private let loadGroupImageButton: UIButton = UIButton(type: .system)
    private let buttonImageView = UIImageView()
    private let skipButton: UIButton = UIButton(type: .system)
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc
    private func loadGroupImageButtonTapped() {
        LoadingView.show(inVC: self)
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true) {
            LoadingView.hide(fromVC: self)
        }
    }
    
    @objc
    private func continueButtonTapped() {
        presenter?.createNewGroup()
    }
    
    @objc
    private func skipButtonTapped() {
        presenter?.createNewGroup()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension LoadGroupImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            loadGroupImageButton.backgroundColor = .clear
            loadGroupImageButton.tintColor = .white
            buttonImageView.image = selectedImage
            loadGroupImageButton.layoutIfNeeded()
        }
        dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension LoadGroupImageViewController: UINavigationControllerDelegate {
    
}

// MARK: - UI Configuration
extension LoadGroupImageViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureGroupImageLabel()
        configureLoadGroupImageButton()
        configureSkipButton()
        configureContinueButton()
    }
    
    private func configureGroupImageLabel() {
        view.addSubview(groupImageLabel)
        groupImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageLabel.text = "Load group's image"
        groupImageLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        
        groupImageLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 40)
        groupImageLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureLoadGroupImageButton() {
        view.addSubview(loadGroupImageButton)
        loadGroupImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        loadGroupImageButton.setTitle("Tap to load photo", for: .normal)
        loadGroupImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        loadGroupImageButton.tintColor = .systemGray
        
        loadGroupImageButton.backgroundColor = .systemGray6
        let width = UIScreen.main.bounds.width / 1.5
        loadGroupImageButton.layer.cornerRadius = width / 5
        
        loadGroupImageButton.addTarget(self, action: #selector(loadGroupImageButtonTapped), for: .touchUpInside)
        
        loadGroupImageButton.setWidth(width)
        loadGroupImageButton.setHeight(width)
        loadGroupImageButton.pinTop(to: groupImageLabel.bottomAnchor, 30)
        loadGroupImageButton.pinCenterX(to: view.centerXAnchor)
        
        
        loadGroupImageButton.addSubview(buttonImageView)
        loadGroupImageButton.bringSubviewToFront(loadGroupImageButton.titleLabel ?? buttonImageView)
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonImageView.contentMode = .scaleAspectFill
        buttonImageView.clipsToBounds = true
        buttonImageView.layer.cornerRadius = loadGroupImageButton.layer.cornerRadius
        
        buttonImageView.setWidth(width)
        buttonImageView.setHeight(width)
        buttonImageView.pinCenter(to: loadGroupImageButton)
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
        
        continueButton.pinBottom(to: skipButton.topAnchor, 10)
        continueButton.pinCenterX(to: view.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
    
    private func configureSkipButton() {
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        skipButton.tintColor = .customPink
        
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
        skipButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 20)
        skipButton.pinCenterX(to: view.centerXAnchor)
    }
}
