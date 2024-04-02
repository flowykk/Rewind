//
//  PreviewObjectPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 20.03.2024.
//

import Foundation
import Photos
import UIKit

final class PreviewObjectPresenter {
    weak var view: PreviewObjectViewController?
    private var router: PreviewObjectRouter
    
    init(view: PreviewObjectViewController?, router: PreviewObjectRouter) {
        self.view = view
        self.router = router
    }
    
    func getMediaInfo() {
        LoadingView.show(inVC: view, backgroundColor: .systemBackground)
        if let mediaId = view?.mediaId {
            requestMediaInfo(mediaId: mediaId)
        } else {
            LoadingView.hide(fromVC: view)
        }
    }
    
    func detailsButtonTapped() {
        if (view?.mediaId) != nil {
            router.navigateToDetails()
        } else {
            print("detailsButtonTapped - no media")
        }
    }
    
    func shareButtonTapped(imageToShare: UIImage) {
        LoadingView.show(inVC: view)
        router.presentShareVC(imageToShare: imageToShare)
    }
    
    func likeButtonTapped(likeButtonState: PreviewObjectViewController.LikeButtonState) {
        LoadingView.show(inView: view?.likeButton, backgroundColor: .clear, indicatorStyle: .medium)
        guard let randomMediaId = view?.mediaId else {
            LoadingView.hide(fromView: view?.likeButton)
            return
        }
        switch likeButtonState {
        case .liked:
            requestUnlikeMedia(mediaId: randomMediaId)
        default:
            requestLikeMedia(mediaId: randomMediaId)
        }
    }
}

// MARK: - Download Image
extension PreviewObjectPresenter {
    func downloadButtonTapped(currentImage: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAsset(from: currentImage)}, completionHandler: { success, error in
                    DispatchQueue.main.async { [weak self] in
                        if success {
                            self?.view?.showSuccessAlert()
                        } else if let error = error {
                            self?.view?.showErrorAlert(message: error.localizedDescription)
                        }
                    }
                })
            case .denied, .restricted:
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showErrorAlert(message: "Access to the gallery is denied or restricted")
                }
            case .limited:
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showErrorAlert(message: "Access to the gallery is limited")
                }
            case .notDetermined:
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showErrorAlert(message: "Access to the gallery is not determined")
                }
            @unknown default:
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showErrorAlert(message: "Something went wrong")
                }
            }
        }
    }
}

// MARK: - Network Request Funcs
extension PreviewObjectPresenter {
    private func requestMediaInfo(mediaId: Int) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.getMediaInfo(mediaId: mediaId, userId: userId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleGetMediaInfoResponse(response)
            }
        }
    }
    
    private func requestLikeMedia(mediaId: Int) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.likeMedia(userId: userId, mediaId: mediaId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleLikeMedia(response)
            }
        }
    }
    
    private func requestUnlikeMedia(mediaId: Int) {
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.unlikeMedia(userId: userId, mediaId: mediaId) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleUnlikeMedia(response)
            }
        }
    }
}


// MARK: - Network Response Handlers
extension PreviewObjectPresenter {
    private func handleGetMediaInfoResponse(_ response: NetworkResponse) {
        if response.success, let json = response.json {
            let currentMedia = Media(json: json)
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureUIForCurrentMedia(currentMedia)
                LoadingView.hide(fromVC: self?.view)
            }
        } else {
            print("something went wrong - handleGetMediaInfoResponse (PreviewObjectPresenter)")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
    
    private func handleLikeMedia(_ response: NetworkResponse) {
        if response.success {
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureLikeButtonUI(newState: .liked)
                LoadingView.hide(fromView: self?.view?.likeButton)
            }
        } else {
            print("something went wrong - handleLikeMedia")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromView: self?.view?.likeButton)
        }
    }
    
    private func handleUnlikeMedia(_ response: NetworkResponse) {
        if response.success {
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureLikeButtonUI(newState: .unliked)
                LoadingView.hide(fromView: self?.view?.likeButton)
            }
        } else {
            print("something went wrong - handleLikeMedia")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromView: self?.view?.likeButton)
        }
    }
}
