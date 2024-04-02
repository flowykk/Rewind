//
//  TagsCollectionPresenterProtocol.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

protocol TagsCollectionPresenterProtocol {
    func updateTagsInCollection(_ newTags: [Tag])
    func addTagToCollection(_ tag: Tag)
    func deleteTag(atIndex index: Int)
}
