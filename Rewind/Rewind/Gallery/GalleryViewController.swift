//
//  GalleryViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class GalleryViewController: UIViewController {
    var presenter: GalleryPresenter?
    
    private let galleryCollection: GalleryCollectionView = GalleryCollectionView()
    private let galleryBackButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        galleryCollection.gallery = self
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
    
    @objc
    private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
    
    @objc
    private func addButtonTapped() {
        presenter?.addButtonTapped()
    }
}

// MARK: - UINavigationControllerDelegate
extension GalleryViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            if toVC is RewindViewController {
                return PopToBottomTransitioning()
            }
        }
        return nil
    }
}

// MARK: - UI Configuration
extension GalleryViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Group name"
        
        configureNavigationBackButton()
        configureAddButton()
        configureGalleryCollection()
        configureGalleryBackButton()
    }
    
    private func configureNavigationBackButton() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func configureAddButton() {
        let addButton = UIButton(type: .system)
        
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .black
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let addButtonBarItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addButtonBarItem
    }
    
    private func configureGalleryCollection() {
        view.addSubview(galleryCollection)
        galleryCollection.translatesAutoresizingMaskIntoConstraints = false
        
        galleryCollection.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        galleryCollection.pinLeft(to: view.leadingAnchor, 0)
        galleryCollection.pinRight(to: view.trailingAnchor, 0)
        galleryCollection.pinBottom(to: view.bottomAnchor, 0)
    }
    
    private func configureGalleryBackButton() {
        view.addSubview(galleryBackButton)
        galleryBackButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "forward.fill", withConfiguration: configuration)
        galleryBackButton.setImage(image, for: .normal)
        
        galleryBackButton.tintColor = .customPink
        galleryBackButton.backgroundColor = .systemBackground
        galleryBackButton.layer.cornerRadius = UIScreen.main.bounds.width / 6 / 2
        
        galleryBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        galleryBackButton.setWidth(UIScreen.main.bounds.width / 6)
        galleryBackButton.setHeight(UIScreen.main.bounds.width / 6)
        galleryBackButton.pinBottom(to: view.bottomAnchor, 50)
        galleryBackButton.pinCenterX(to: view.centerXAnchor)
    }
}
