//
//  GroupSettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation
import UIKit

final class GroupSettingsPresenter {
    private weak var view: GroupSettingsViewController?
    private var router: GroupSettingsRouter
    
    init(view: GroupSettingsViewController?, router: GroupSettingsRouter) {
        self.view = view
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToGroup()
    }
    
    func updateName(to name: String) {
        view?.setGroupName(name)
    }
    
    func generalRowSelected(_ row: GroupGeneralTableView.GroupGeneralRow) {
        switch row {
        case .editGroupImage:
            router.presentEditImageAlert()
        case .editGroupName:
            router.presentEditGroupName()
        }
    }
    
    func riskyZoneRowSelected(_ row: GroupRiskyZoneTableView.GroupRiskyZoneRow) {
        switch row {
        case .leaveGroup:
            router.presentLeaveGroupConfirmationAlert()
        case .deleteGroup:
            router.presentDeleteGroupConfirmationAlert()
        }
    }
    
    func openPhotoLibraryButtonTapped() {
        LoadingView.show(in: view)
        router.presentImagePicker()
    }
    
    func newImageSelected(originalImage: UIImage) {
        LoadingView.show(in: view)
        
        let bigImage = originalImage.resize(toDimension: 600)
        let miniImage = originalImage.resize(toDimension: 256)
        
        let bigImageData = bigImage.jpegData(compressionQuality: 1)
        let miniImageData = miniImage.jpegData(compressionQuality: 1)
        
        if let bigImageData, let miniImageData {
            requestUpdateGroupImage(bigImageData: bigImageData, miniImageData: miniImageData)
        }
    }
    
    func removeUserFromGroup() {
        LoadingView.show(in: view)
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        requestRemoveUserFromGroup(userId: userId)
    }
    
    func deleteGroup() {
        LoadingView.show(in: view)
        requestDeleteGroup()
    }
}

// MARK: - Network Request Funcs
extension GroupSettingsPresenter {
    private func requestUpdateGroupImage(bigImageData: Data, miniImageData: Data) {
        guard let groupId = DataManager.shared.getCurrentGroup()?.id else { return }
        let bigImageB64S = bigImageData.base64EncodedString()
        let miniImageB64S = miniImageData.base64EncodedString()
        
        NetworkService.updateGroupImage(groupId: groupId, bigImageB64String: bigImageB64S, miniImageB64String: miniImageB64S) { [weak self] response in
            DispatchQueue.global().async {
                self?.handleUpdateGroupImageResponse(response, groupId: groupId, bigImageData: bigImageData, miniImageData: miniImageData)
            }
        }
    }
    
    private func requestRemoveUserFromGroup(userId: Int) {
        guard let groupId = DataManager.shared.getCurrentGroup()?.id else { return }
        NetworkService.removeMemberFromGroup(groupId: groupId, memberId: userId) { [weak self] response in
            DispatchQueue.main.async {
                self?.handleRemoveMemberFromGroupResponse(response, groupId: groupId)
            }
        }
    }
    
    private func requestDeleteGroup() {
        guard let groupId = DataManager.shared.getCurrectGroupId() else { return }
        NetworkService.deleteGroup(groupId: groupId) { [weak self] response in
            self?.handleDeleteGroupResponse(response, groupId: groupId)
        }
    }
}

// MARK: - Network Response Handlers
extension GroupSettingsPresenter {
    private func handleUpdateGroupImageResponse(_ response: NetworkResponse, groupId: Int, bigImageData: Data, miniImageData: Data) {
        if response.success {
            DataManager.shared.setCurrentGroupBigImage(bigImageData)
            DataManager.shared.setCurrentGroupMiniImage(miniImageData)
            DataManager.shared.updateGroupWithImage(bigImageData: bigImageData, miniImageData: miniImageData, forGroupWithId: groupId)
            DispatchQueue.main.async { [weak self] in
                self?.view?.setGroupImage(to: bigImageData)
                LoadingView.hide(from: self?.view)
            }
        } else {
            print("something went wrong")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
    
    private func handleRemoveMemberFromGroupResponse(_ response: NetworkResponse, groupId: Int) {
        if response.success {
            DataManager.shared.removeGroupFromGroups(groupId: groupId)
            DataManager.shared.resetCurrentGroup()
            DispatchQueue.main.async { [weak self] in
                self?.router.navigateToRewind()
                LoadingView.hide(from: self?.view)
            }
        } else {
            print("something went wrong")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
    
    private func handleDeleteGroupResponse(_ response: NetworkResponse, groupId: Int) {
        if response.success {
            DataManager.shared.removeGroupFromGroups(groupId: groupId)
            DataManager.shared.resetCurrentGroup()
            DispatchQueue.main.async { [weak self] in
                self?.router.navigateToRewind()
                LoadingView.hide(from: self?.view)
            }
        } else {
            print("something went wrong")
            print(response)
        }
        DispatchQueue.main.async { [weak self] in
            LoadingView.hide(from: self?.view)
        }
    }
}
