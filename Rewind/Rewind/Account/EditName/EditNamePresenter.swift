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
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        NetworkService.updateUserName(userId: userId, newName: name) { response in
            DispatchQueue.main.async {
                if response.success {
                    if response.message != nil {
                        self.view?.delegate?.presenter?.didUpdateName(to: name)
                        UserDefaults.standard.set(name, forKey: "UserName")
                        self.view?.dismiss(animated: true)
                    }
                } else {
                    print(response.message as Any)
                    print(response.statusCode as Any)
                }
            }
        }
    }
}
