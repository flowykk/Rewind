//
//  EditNamePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.02.2024.
//

import Foundation
import UIKit

final class EditNamePresenter {
    private weak var view: EditNameViewController?
    
    init(view: EditNameViewController) {
        self.view = view
    }
    
    func updateName(with name: String) {
        LoadingView.show(inVC: view)
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.updateUserName(userId: userId, newName: name) { response in
            DispatchQueue.main.async {
                if response.success {
                    self.view?.delegate?.presenter?.didUpdateName(to: name)
                    UserDefaults.standard.set(name, forKey: "UserName")
                    self.view?.dismiss(animated: true) {
                        LoadingView.hide(fromVC: self.view)
                    }
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
            }
        }
    }
}
