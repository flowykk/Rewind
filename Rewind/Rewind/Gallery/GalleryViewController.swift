//
//  GalleryViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    private let galleryCollection: GalleryCollectionView = GalleryCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc
    private func backButtonTapped() {
        print("go back")
    }
    
    @objc
    private func addButtonTapped() {
        let vc = ObjectsMenuViewController()
        
        vc.modalPresentationStyle = .popover
        
        let height = Double(2 * 40)
        
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width / 2, height: height)
        
        vc.popoverPresentationController?.delegate = vc
        vc.popoverPresentationController?.permittedArrowDirections = []
        
        if let addButton = navigationItem.rightBarButtonItem?.customView as? UIButton {
            vc.popoverPresentationController?.sourceView = addButton
            vc.popoverPresentationController?.sourceRect = CGRect(x: addButton.bounds.midX, y: addButton.bounds.maxY, width: 0, height: 0)
        }
        
        present(vc, animated: true)
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
