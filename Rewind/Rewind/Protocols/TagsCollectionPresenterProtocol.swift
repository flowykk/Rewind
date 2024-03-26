//
//  TagsCollectionPresenterProtocol.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

protocol TagsCollectionPresenterProtocol {
    func initTagsCollection()
    func addTag(_ title: String)
    func deleteTag(atIndex index: Int)
}
