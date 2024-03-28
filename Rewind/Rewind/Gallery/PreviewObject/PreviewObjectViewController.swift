//
//  PreviewObjectViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 20.03.2024.
//

import UIKit

final class PreviewObjectViewController: UIViewController {
    var presenter: PreviewObjectPresenter?
    
    var image: UIImage?
    var isFavourite: Bool = false
    
    private let imageView: UIImageView = UIImageView()
    private let imageInfoView: ObjectInfoView = ObjectInfoView()
    private let downloadButton: UIButton = UIButton(type: .system)
    private let settingsButton: UIButton = UIButton(type: .system)
    private let shareButton: UIButton = UIButton(type: .system)
    private let favoriteButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        configureGestures()
        configureUI()
    }
    
    private func configureGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullScreen))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideImage))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissFullScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleTapOutsideImage(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !imageView.frame.contains(location) && !imageInfoView.frame.contains(location) {
            dismissFullScreen()
        }
    }

    @objc
    private func favouriteButtonTapped() {
        presenter?.favouriteButtonTapped(favourite: isFavourite)
    }
    
    func setFavouriteButton(imageName: String, tintColor: UIColor) {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = tintColor
    }
}

extension PreviewObjectViewController {
    private func configureUI() {
        configureBlurEffect()
        configureImageView()
        configureImageInfoView()
        
        configureSettingsButton()
        configureDownloadButton()
        
        configureShareButton()
        configureFavoriteButton()
    }
    
    private func configureBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        
        imageView.setWidth(UIScreen.main.bounds.width - 15)
        imageView.setHeight(UIScreen.main.bounds.width - 15)
        imageView.pinTop(to: view.topAnchor, UIScreen.main.bounds.height / 4)
        imageView.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureImageInfoView() {
        imageView.addSubview(imageInfoView)
        imageInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        imageInfoView.viewWidth = UIScreen.main.bounds.width * 0.4
        
        imageInfoView.pinCenterX(to: imageView.centerXAnchor)
        imageInfoView.pinBottom(to: imageView.bottomAnchor, 5)
    }
    
    private func configureDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "square.and.arrow.down", withConfiguration: configuration)
        downloadButton.setImage(image, for: .normal)
        
        downloadButton.tintColor = .darkGray
        downloadButton.backgroundColor = UIColor(white: 1, alpha: 0.75)
        downloadButton.layer.cornerRadius = 35 / 2
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        
        downloadButton.setWidth(35)
        downloadButton.setHeight(35)
        downloadButton.pinRight(to: settingsButton.leadingAnchor, 10)
        downloadButton.pinCenterY(to: settingsButton.centerYAnchor)
    }
    
    private func configureSettingsButton() {
        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: configuration)
        settingsButton.setImage(image, for: .normal)
        
        settingsButton.tintColor = .darkGray
        settingsButton.backgroundColor = UIColor(white: 1, alpha: 0.75)
        settingsButton.layer.cornerRadius = 35 / 2
        
        settingsButton.setWidth(35)
        settingsButton.setHeight(35)
        settingsButton.pinRight(to: imageInfoView.leadingAnchor, 10)
        settingsButton.pinCenterY(to: imageInfoView.centerYAnchor)
    }
    
    private func configureShareButton() {
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)
        shareButton.setImage(image, for: .normal)
        
        shareButton.tintColor = .darkGray
        shareButton.backgroundColor = UIColor(white: 1, alpha: 0.75)
        shareButton.layer.cornerRadius = 35 / 2
        shareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        
        shareButton.setWidth(35)
        shareButton.setHeight(35)
        shareButton.pinLeft(to: imageInfoView.trailingAnchor, 10)
        shareButton.pinCenterY(to: imageInfoView.centerYAnchor)
    }
    
    private func configureFavoriteButton() {
        view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "heart", withConfiguration: configuration)
        favoriteButton.setImage(image, for: .normal)
        
        favoriteButton.tintColor = .darkGray
        favoriteButton.backgroundColor = UIColor(white: 1, alpha: 0.75)
        favoriteButton.layer.cornerRadius = 35 / 2
        favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        favoriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        favoriteButton.setWidth(35)
        favoriteButton.setHeight(35)
        favoriteButton.pinLeft(to: shareButton.trailingAnchor, 10)
        favoriteButton.pinCenterY(to: shareButton.centerYAnchor)
    }
}
