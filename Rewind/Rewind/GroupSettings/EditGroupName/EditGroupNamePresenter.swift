//
//  EditGroupNamePresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation

final class EditGroupNamePresenter {
    private weak var view: EditGroupNameViewController?
    
    init(view: EditGroupNameViewController?) {
        self.view = view
    }
    
    func updateName(to name: String?) {
        guard let name = name, Validator.isValidGroupName(name) else {
            AlertHelper.showAlert(from: view, withTitle: "Error", message: "Invalid group name")
            return
        }
        
        LoadingView.show(inVC: view)
        requestGroupNameUpdate(newName: name)
    }
}

// MARK: - Network Request Funcs
extension EditGroupNamePresenter {
    private func requestGroupNameUpdate(newName: String) {
        guard let groupId = DataManager.shared.getCurrentGroup()?.id else { return }
        NetworkService.updateGroupName(groupId: groupId, newName: newName) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleUpdateGroupNameResponse(response, groupId: groupId, newName: newName)
            }
        }
    }
}

extension EditGroupNamePresenter {
    private func handleUpdateGroupNameResponse(_ response: NetworkResponse, groupId: Int, newName: String) {
        if response.success {
            DataManager.shared.setCurrentGroupName(newName)
            DataManager.shared.updateGroupWithName(newName, forGroupWithId: groupId)
            DispatchQueue.main.async { [weak self] in
                self?.view?.groupSettingVC?.setGroupName(newName)
                self?.view?.dismiss(animated: true) {
                    LoadingView.hide(fromVC: self?.view)
                }
            }
        } else {
            print(response.message as Any)
            print(response.statusCode as Any)
        }
        DispatchQueue.main.async { [weak self] in
            self?.view?.dismiss(animated: true) {
                LoadingView.hide(fromVC: self?.view)
            }
        }
    }
}
