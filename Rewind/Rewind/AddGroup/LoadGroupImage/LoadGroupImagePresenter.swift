//
//  LoadGroupImagePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation

final class LoadGroupImagePresenter {
    private weak var view: LoadGroupImageViewController?
    
    init(view: LoadGroupImageViewController?) {
        self.view = view
    }
    
    func createNewGroup() {
        print("create new group")
        view?.dismiss(animated: true, completion: { [weak self] in
            self?.view?.enterGroupNameVC?.dismiss(animated: true)
        })
    }
}
