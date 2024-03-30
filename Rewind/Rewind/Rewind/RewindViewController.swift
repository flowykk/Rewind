//
//  RewindViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 02.03.2024.
//

import UIKit

final class RewindViewController: UIViewController {
    var presenter: RewindPresenter?
    
    var likeButtonState: LikeButtonState = .unliked
    var randomMediaId: Int? = nil
    
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
                return .systemGray2
            }
        }
    }
    
    private let goToGroupButton: UIButton = UIButton(type: .system)
    private let groupImageView: UIImageView = UIImageView()
    private let currentGroupView: UIView = UIView()
    private let showGroupsMenuButton: UIButton = UIButton(type: .system)
    private let goToAccountButton: UIButton = UIButton(type: .system)
    let imageView: UIImageView = UIImageView()
    private let imageInfoView: ObjectInfoView = ObjectInfoView()
    private let settingsButton: UIButton = UIButton(type: .system)
    private let detailsButton: UIButton = UIButton(type: .system)
    private let downloadButton: UIButton = UIButton(type: .system)
    private let rewindButton: UIButton = UIButton(type: .system)
    let likeButton: UIButton = UIButton(type: .system)
    private let galleryButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        configureUI()
        presenter?.getInitialRewindScreenData()
        
        if let navigationController = navigationController {
            let navigationBarHeight = navigationController.navigationBar.frame.height
            print("Navigation bar height: \(navigationBarHeight)")
        } else {
            print("Navigation controller is not available.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUIForCurrentGroup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
    
    @objc
    private func goToGroupButtonTapped() {
        presenter?.goToGroup()
    }
    
    @objc
    private func showGroupsMenuButtonTapped() {
        presenter?.showGroupsMenuButtonTapped()
    }
    
    @objc
    private func goToAccountButtonTapped() {
        presenter?.goToAccount()
    }
    
    @objc
    private func settingButtonTapped() {
        presenter?.settingsButtonTapped()
    }
    
    @objc
    private func detailsButtonTapped() {
        presenter?.detailsButtonTapped()
    }
    
    @objc
    private func downloadButtonTapped() {
        if let image = imageView.image {
            presenter?.downloadButtonTapped(currentImage: image)
        }
    }
    
    @objc
    private func rewindButtonTapped() {
        presenter?.getRandomMedia()
    }
    
    @objc
    private func likeButtonTapped() {
        presenter?.likeButtonTapped(likeButtonState: likeButtonState)
    }
    
    @objc
    private func galleryButtonTapped() {
        presenter?.galleryButtonTapped()
    }
    
    func configureUIForCurrentGroup() {
        if let currentGroup = DataManager.shared.getCurrentGroup() {
            navigationItem.leftBarButtonItem?.isEnabled = true
            showGroupsMenuButton.setTitle(currentGroup.name, for: .normal)
            if let miniImage = currentGroup.miniImage {
                groupImageView.image = miniImage
            } else {
                if let defaultImage = UIImage(named: "groupImage") {
                    groupImageView.image = defaultImage
                }
            }
            if let gallerySize = currentGroup.gallerySize {
                galleryButton.setTitle("\(gallerySize) media", for: .normal)
            } else {
                galleryButton.setTitle("0 media", for: .normal)
            }
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = false
            showGroupsMenuButton.setTitle("Select group", for: .normal)
            if let defaultImage = UIImage(named: "groupImage") {
                groupImageView.image = defaultImage
            }
            galleryButton.setTitle("0 media", for: .normal)
        }
    }
    
    func configureUIForRandomMedia(_ randomMedia: Media?) {
        imageView.image = randomMedia?.bigImage ?? UIImage(named: "defaultImage")
        imageInfoView.configureUIForAuthor(randomMedia?.author, withDateAdded: randomMedia?.dateAdded)
        if let liked = randomMedia?.liked {
            configureLikeButtonUI(newState: liked ? .liked : .unliked)
        }
    }
    
    func configureLikeButtonUI(newState: LikeButtonState) {
        likeButtonState = newState
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: newState.imageName, withConfiguration: configuration)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = newState.tintColor
    }
    
    func setCurrentGroup(to group: Group) {
        showGroupsMenuButton.setTitle(group.name, for: .normal)
        if let miniImage = group.miniImage {
            groupImageView.image = miniImage
        } else {
            guard let defaultImage = UIImage(named: "groupImage") else { return }
            groupImageView.image = defaultImage
        }
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

// MARK: - UINavigationControllerDelegate
extension RewindViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            if toVC is GroupViewController {
                return PushTransitioning()
            } else if toVC is GalleryViewController {
                return PushFromBottomTransitioning()
            }
        }
        return nil
    }
}

// MARK: - UI Configuration
extension RewindViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureGoToGroupButton()
        configureCurrentGroupView()
        configureGoToAccountButton()
        
        configureImageView()
        configureImageInfoView()
        configureDetailsButton()
        configureSettingsButton()
        
        configureRewindButton()
        configureDownloadButton()
        configureLikeButton()
        
        configureGalleryButton()
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: goToGroupButton)
        navigationItem.titleView = currentGroupView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: goToAccountButton)
    }
    
    private func configureGoToGroupButton() {
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "person.2.fill", withConfiguration: configuration)
        let disabledStateImage = image?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        goToGroupButton.setImage(image, for: .normal)
        goToGroupButton.setImage(disabledStateImage, for: .disabled)
        
        goToGroupButton.tintColor = .darkGray
        goToGroupButton.backgroundColor = .systemGray6
        goToGroupButton.layer.cornerRadius = 40 / 2
        
        goToGroupButton.addTarget(self, action: #selector(goToGroupButtonTapped), for: .touchUpInside)
        
        goToGroupButton.setWidth(40)
        goToGroupButton.setHeight(40)
    }
    
    private func configureCurrentGroupView() {
        currentGroupView.translatesAutoresizingMaskIntoConstraints = false
        
        currentGroupView.backgroundColor = .systemGray6
        currentGroupView.layer.cornerRadius = 40 / 2
        
        currentGroupView.setWidth(170)
        currentGroupView.setHeight(40)
        
        
        currentGroupView.addSubview(groupImageView)
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageView.contentMode = .scaleAspectFill
        groupImageView.clipsToBounds = true
        groupImageView.layer.cornerRadius = 35 / 2
        
        groupImageView.setWidth(35)
        groupImageView.setHeight(35)
        groupImageView.pinLeft(to: currentGroupView.leadingAnchor, 3)
        groupImageView.pinCenterY(to: currentGroupView.centerYAnchor)
        
        
        currentGroupView.addSubview(showGroupsMenuButton)
        showGroupsMenuButton.translatesAutoresizingMaskIntoConstraints = false
        
        showGroupsMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        showGroupsMenuButton.setImage(image, for: .normal)
        
        showGroupsMenuButton.tintColor = .black
        showGroupsMenuButton.semanticContentAttribute = .forceRightToLeft
        showGroupsMenuButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        showGroupsMenuButton.addTarget(self, action: #selector(showGroupsMenuButtonTapped), for: .touchUpInside)
        
        showGroupsMenuButton.setHeight(35)
        showGroupsMenuButton.pinLeft(to: groupImageView.trailingAnchor, 2)
        showGroupsMenuButton.pinRight(to: currentGroupView.trailingAnchor, 3)
        showGroupsMenuButton.pinCenterY(to: currentGroupView.centerYAnchor)
    }
    
    private func configureGoToAccountButton() {
        goToAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "person.fill", withConfiguration: configuration)
        goToAccountButton.setImage(image, for: .normal)
        
        goToAccountButton.tintColor = .darkGray
        goToAccountButton.backgroundColor = .systemGray6
        goToAccountButton.layer.cornerRadius = 40 / 2
        
        goToAccountButton.addTarget(self, action: #selector(goToAccountButtonTapped), for: .touchUpInside)
        
        goToAccountButton.setWidth(40)
        goToAccountButton.setHeight(40)
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
        view.addSubview(imageInfoView)
        imageInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        imageInfoView.pinCenterX(to: imageView.centerXAnchor)
        imageInfoView.pinBottom(to: imageView.bottomAnchor, 5)
    }
    
    private func configureSettingsButton() {
        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: configuration)
        settingsButton.setImage(image, for: .normal)
        
        settingsButton.tintColor = .secondaryLabel
        settingsButton.backgroundColor = .systemGray6
        settingsButton.layer.cornerRadius = 35 / 2
        
        settingsButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        
        settingsButton.setWidth(35)
        settingsButton.setHeight(35)
        settingsButton.pinRight(to: detailsButton.leadingAnchor, 10)
        settingsButton.pinCenterY(to: detailsButton.centerYAnchor)
    }
    
    private func configureDetailsButton() {
        view.addSubview(detailsButton)
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        detailsButton.setTitle("View details", for: .normal)
        detailsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 9, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        detailsButton.setImage(image, for: .normal)
        
        detailsButton.tintColor = .secondaryLabel
        detailsButton.backgroundColor = .systemGray6
        detailsButton.layer.cornerRadius = 35 / 2
        
        detailsButton.semanticContentAttribute = .forceRightToLeft
        detailsButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: -7)
        
        let imageSize = image?.size ?? CGSize.zero
        let titleSize = detailsButton.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        
        detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
        
        detailsButton.setWidth((titleSize.width + imageSize.width) * 1.3)
        detailsButton.setHeight(35)
        detailsButton.pinBottom(to: imageView.topAnchor, 10)
        detailsButton.pinCenterX(to: imageView.centerXAnchor)
    }
    
    private func configureDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "square.and.arrow.down", withConfiguration: configuration)
        downloadButton.setImage(image, for: .normal)
        
        downloadButton.tintColor = .systemGray2
        downloadButton.backgroundColor = .systemGray6
        downloadButton.layer.cornerRadius = 45 / 2
        
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        downloadButton.setWidth(45)
        downloadButton.setHeight(45)
        downloadButton.pinRight(to: rewindButton.leadingAnchor, 20)
        downloadButton.pinCenterY(to: rewindButton.centerYAnchor)
    }
    
    private func configureRewindButton() {
        view.addSubview(rewindButton)
        rewindButton.translatesAutoresizingMaskIntoConstraints = false
        
        rewindButton.setTitle("Rewind", for: .normal)
        rewindButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "forward.fill", withConfiguration: configuration)
        rewindButton.setImage(image, for: .normal)
        
        rewindButton.tintColor = .customPink
        rewindButton.semanticContentAttribute = .forceRightToLeft
        rewindButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: -7)
        
        rewindButton.layer.borderColor = UIColor.customPink.cgColor
        rewindButton.layer.borderWidth = 4
        rewindButton.layer.cornerRadius = 35
        
        rewindButton.addTarget(self, action: #selector(rewindButtonTapped), for: .touchUpInside)
        
        rewindButton.setWidth(UIScreen.main.bounds.width * 0.6)
        rewindButton.setHeight(70)
        rewindButton.pinTop(to: imageView.bottomAnchor, 10)
        rewindButton.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureLikeButton() {
        view.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "heart", withConfiguration: configuration)
        likeButton.setImage(image, for: .normal)
        
        likeButton.tintColor = .systemGray2
        likeButton.backgroundColor = .systemGray6
        likeButton.layer.cornerRadius = 45 / 2
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        likeButton.setWidth(45)
        likeButton.setHeight(45)
        likeButton.pinLeft(to: rewindButton.trailingAnchor, 20)
        likeButton.pinCenterY(to: rewindButton.centerYAnchor)
    }
    
    private func configureGalleryButton() {
        view.addSubview(galleryButton)
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        
        galleryButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        let font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.compact.down", withConfiguration: configuration)
        galleryButton.setImage(image, for: .normal)
        
        galleryButton.tintColor = .darkGray
        galleryButton.semanticContentAttribute = .forceRightToLeft
        
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        
        galleryButton.imageView?.pinCenterX(to: galleryButton.centerXAnchor)
        
        if let tl = galleryButton.titleLabel {
            galleryButton.titleLabel?.pinCenterX(to: galleryButton.centerXAnchor)
            galleryButton.imageView?.pinTop(to: tl.bottomAnchor, -2.5)
        }
        
        galleryButton.setHeight(80)
        galleryButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 10)
        galleryButton.pinCenterX(to: view.centerXAnchor)
    }
}
