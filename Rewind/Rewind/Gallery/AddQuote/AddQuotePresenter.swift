//
//  AddQuotePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation
import UIKit

final class AddQuotePresenter: TagsCollectionPresenterProtocol {
    private weak var view: AddQuoteViewController?
    weak var tagsCollection: TagsCollectionView?
    weak var colorsTable: ColorsTableView?
    private let router: AddQuoteRouter
    
    var quote: Quote = Quote()
    
    init(view: AddQuoteViewController?, router: AddQuoteRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToGallery()
    }
    
    func quoteSettingsButtonTapped() {
        router.presentQuoteSettings()
    }
    
    func addTagButtonTapped() {
        router.presentAddTag()
    }
    
    func continueButtonTapped() {
        if let originalImage = quote.image, let groupId = DataManager.shared.getCurrectGroupId(), let tagsCollection = tagsCollection {
            LoadingView.show(inVC: view)
            
            let tagTexts = tagsCollection.tags.map { $0.text }
            
            let bigImage = originalImage.resize(toDimension: 600)
            let miniImage = originalImage.resize(toDimension: 256)
            
            let bigImageData = bigImage.jpegData(compressionQuality: 1)
            let miniImageData = miniImage.jpegData(compressionQuality: 1)
            
            let bigImageB64S = bigImageData?.base64EncodedString()
            let miniImageB64S = miniImageData?.base64EncodedString()
            
            if let bigImageB64S, let miniImageB64S {
                let userId = UserDefaults.standard.integer(forKey: "UserId")
                requestLoadMediaToGroup(groupId: groupId, userId: userId, isPhoto: 0, bigImageB64String: bigImageB64S, miniImageB64String: miniImageB64S, tagTexts: tagTexts)
            }
        }
    }
    
    func generateQuoteImage() {
        LoadingView.show(inVC: view)
        if let text = quote.text {
            let backgroundColor = quote.backgroundColor
            let textColor = quote.textColor
            let author = quote.author ?? ""
            
            let quoteImage = QuoteImageGenerator.convertToImage(quote: text, author: author, backgroundColor: backgroundColor, textColor: textColor)
            
            quote.image = quoteImage
            
            view?.configureUIForQuoteImage(image: quoteImage)
        }
        LoadingView.hide(fromVC: view)
    }
    
    func rowSelected(_ row: ColorsTableView.ColorRow) {
        LoadingView.show(inVC: view)
        view?.currentColorSelection = row
        switch row {
        case .backgroundColor:
            router.presentColorPicker(selectedColor: quote.backgroundColor)
        case .textColor:
            router.presentColorPicker(selectedColor: quote.textColor)
        }
    }
    
    func colorPicked(selectedColor: UIColor) {
        if view?.currentColorSelection == .backgroundColor {
            quote.backgroundColor = selectedColor
        } else if view?.currentColorSelection == .textColor {
            quote.textColor = selectedColor
        }
        view?.configureUIForColor(selectedColor)
        colorsTable?.configureUIForColor(selectedColor, inRow: view?.currentColorSelection)
        generateQuoteImage()
    }
    
    func updateTagsInCollection(_ tags: [Tag]) {
        
    }
    
    func addTagToCollection(_ tag: Tag) {
        tagsCollection?.tags.append(tag)
        tagsCollection?.reloadData()
    }
    
    func deleteTag(atIndex index: Int) {
        tagsCollection?.tags.remove(at: index)
        tagsCollection?.reloadData()
        view?.configureUIForTags()
        view?.updateViewsHeight()
    }
}

// MARK: - Network Request Funcs
extension AddQuotePresenter {
    private func requestLoadMediaToGroup(groupId: Int, userId: Int, isPhoto: Int, bigImageB64String: String, miniImageB64String: String, tagTexts: [String]) {
        NetworkService.loadMediaToGroup(
            groupId: groupId,
            userId: userId,
            isPhoto: isPhoto,
            bigImageB64String: bigImageB64String,
            miniImageB64String: miniImageB64String,
            tagTexts: tagTexts
        ) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleLoadMediaToGroup(response)
            }
        }
    }
}

// MARK: - Network Response Handlers
extension AddQuotePresenter {
    private func handleLoadMediaToGroup(_ response: NetworkResponse) {
        if response.success {
            DataManager.shared.incrementCurrentGroupGallerySizer()
            DispatchQueue.main.async { [weak self] in
                LoadingView.hide(fromVC: self?.view)
                self?.router.navigateToGallery()
            }
        } else {
            print("something went wrong - handleLoadMediaToGroup (AddQuotePresenter)")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(fromVC: self?.view)
        }
    }
}
