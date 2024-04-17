//
//  PreviewObjectViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 20.03.2024.
//

import UIKit

final class PreviewObjectViewController: UIViewController {
    var presenter: PreviewObjectPresenter?
    
    var galleryVC: GalleryViewController?
    var likeButtonState: LikeButtonState = .unliked
    var mediaId: Int?
    
    enum LikeButtonState {
        case liked
        case unliked
        
        var imageName: String {
            switch self {
            case .liked:
                return "heart.fill"
            case .unliked:
                return "heart"
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .liked:
                return .customPink
            case .unliked:
                return .darkGray
            }
        }
    }
    
    private let imageView: UIImageView = UIImageView()
    private let imageInfoView: ObjectInfoView = ObjectInfoView()
    private let downloadButton: UIButton = UIButton(type: .system)
    private let detailsButton: UIButton = UIButton(type: .system)
    private let shareButton: UIButton = UIButton(type: .system)
    let likeButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        configureGestures()
        configureUI()
        presenter?.getMediaInfo()
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
    private func downloadButtonTapped() {
        if let image = imageView.image {
            presenter?.downloadButtonTapped(currentImage: image)
        }
    }
    
    @objc
    private func detailsButtonTapped() {
        presenter?.detailsButtonTapped()
    }
    
    @objc
    private func shareButtonTapped() {
        if let image = imageView.image {
            presenter?.shareButtonTapped(imageToShare: image)
        }
    }

    @objc
    private func likeButtonTapped() {
        presenter?.likeButtonTapped(likeButtonState: likeButtonState)
    }
    
    func configureUIForCurrentMedia(_ currentMedia: Media?) {
        imageView.image = currentMedia?.bigImage ?? UIImage(named: "defaultImage")
        imageInfoView.configureUIForAuthor(currentMedia?.author, withDateAdded: currentMedia?.shortDateAdded)
        if let liked = currentMedia?.liked {
            configureLikeButtonUI(newState: liked ? .liked : .unliked)
        } else {
            configureLikeButtonUI(newState: .unliked)
        }
    }
    
    func configureLikeButtonUI(newState: LikeButtonState) {
        likeButtonState = newState
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: newState.imageName, withConfiguration: configuration)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = newState.tintColor
    }
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "The image has been successfully saved to your gallery", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
        downloadButton.backgroundColor = .systemBackground.withAlphaComponent(0.75)
        downloadButton.layer.cornerRadius = 35 / 2
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        downloadButton.setWidth(35)
        downloadButton.setHeight(35)
        downloadButton.pinRight(to: detailsButton.leadingAnchor, 10)
        downloadButton.pinCenterY(to: detailsButton.centerYAnchor)
    }
    
    private func configureSettingsButton() {
        view.addSubview(detailsButton)
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: configuration)
        detailsButton.setImage(image, for: .normal)
        
        detailsButton.tintColor = .darkGray
        detailsButton.backgroundColor = .systemBackground.withAlphaComponent(0.75)
        detailsButton.layer.cornerRadius = 35 / 2
        
        detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
        
        detailsButton.setWidth(35)
        detailsButton.setHeight(35)
        detailsButton.pinRight(to: imageInfoView.leadingAnchor, 10)
        detailsButton.pinCenterY(to: imageInfoView.centerYAnchor)
    }
    
    private func configureShareButton() {
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)
        shareButton.setImage(image, for: .normal)
        
        shareButton.tintColor = .darkGray
        shareButton.backgroundColor = .systemBackground.withAlphaComponent(0.75)
        shareButton.layer.cornerRadius = 35 / 2
        shareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        shareButton.setWidth(35)
        shareButton.setHeight(35)
        shareButton.pinLeft(to: imageInfoView.trailingAnchor, 10)
        shareButton.pinCenterY(to: imageInfoView.centerYAnchor)
    }
    
    private func configureFavoriteButton() {
        view.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "heart", withConfiguration: configuration)
        likeButton.setImage(image, for: .normal)
        
        likeButton.tintColor = .darkGray
        likeButton.backgroundColor = .systemBackground.withAlphaComponent(0.75)
        likeButton.layer.cornerRadius = 35 / 2
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        likeButton.setWidth(35)
        likeButton.setHeight(35)
        likeButton.pinLeft(to: shareButton.trailingAnchor, 10)
        likeButton.pinCenterY(to: shareButton.centerYAnchor)
    }
}
