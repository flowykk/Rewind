//
//  LaunchViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import UIKit

final class LaunchViewController: UIViewController {
    var presenter: LaunchPresenter?
    
    private let launchImageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        navigationController?.isNavigationBarHidden = true
        configureLaunchImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - UINavigationControllerDelegate
extension LaunchViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return DisappearingTransitioning()
        }
        return nil
    }
}

// MARK: - UI Configuration
extension LaunchViewController {
    private func configureLaunchImage() {
        view.addSubview(launchImageView)
        launchImageView.translatesAutoresizingMaskIntoConstraints = false
        
        launchImageView.image = DataManager.shared.getLaunchImage()
        
        launchImageView.pinLeft(to: view.leadingAnchor)
        launchImageView.pinRight(to: view.trailingAnchor)
        launchImageView.pinTop(to: view.topAnchor)
        launchImageView.pinBottom(to: view.bottomAnchor)
    }
}
