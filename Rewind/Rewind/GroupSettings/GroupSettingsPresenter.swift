//
//  GroupSettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 25.03.2024.
//

import Foundation

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
    
    func generalRowSelected(_ row: GroupGeneralTableView.GroupGeneralRow) {
        switch row {
        case .editGroupImage:
            print("edit image")
        case .editGroupName:
            print("edit name")
            //        default:
            //            print("undefined")
            //        }
        }
    }
    
    func riskyZoneRowSelected(_ row: GroupRiskyZoneTableView.GroupRiskyZoneRow) {
        switch row {
        case .leaveGroup:
            print("leave group")
        case .deleteGroup:
            print("delete group")
            //        default:
            //            print("undefined")
            //        }
        }
    }
}
