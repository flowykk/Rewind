//
//  SettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 05.03.2024.
//

import Foundation

final class SettingsPresenter {
    private weak var view: SettingsViewController?
    weak var tagsCollection: TagsCollectionView?
    private var router: SettingsRouter
    
    init(view: SettingsViewController?, router: SettingsRouter) {
        self.view = view
        self.router = router
    }
    
    func continueButtonTapped() {
        view?.dismiss(animated: true)
    }
    
    func initTagsCollection() {
        tagsCollection?.tags = view?.tags ?? []
    }
    
    func addTagButtonTapped() {
        router.presentAddSearchTag()
    }
    
    func deleteTag(atIndex index: Int) {
        view?.tags.remove(at: index)
        view?.updateUI()
        tagsCollection?.tags = view?.tags ?? []
        tagsCollection?.reloadData()
    }
    
    func addTag(_ title: String) {
        view?.tags.append(title)
        view?.updateUI()
        tagsCollection?.tags = view?.tags ?? []
        tagsCollection?.reloadData()
    }
}
