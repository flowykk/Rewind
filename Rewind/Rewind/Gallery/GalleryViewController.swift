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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollection.gallery = self
        configureUI()
    }
    
    @objc
    private func backButtonTapped() {
        print("go back")
    }
    
    @objc
    private func addButtonTapped() {
        presenter?.addButtonTapped()
    }
}

extension GalleryViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Group name"
        
        configureBackButton()
        configureAddButton()
        configureGalleryCollection()
    }
    
    private func configureBackButton() {
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
}
