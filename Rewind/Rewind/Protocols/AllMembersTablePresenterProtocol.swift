//
//  AllMembersTablePresenterProtocol.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 26.03.2024.
//

import Foundation

protocol AllMembersTablePresenterProtocol {
    func rowSelected(_ row: MembersTableView.CellType)
    
    func deleteMemberButtonTapped(memberId: Int)
}
