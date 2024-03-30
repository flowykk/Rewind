//
//  AddTagBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

final class AddTagBuilder {
    static func build() -> AddTagViewController {
        let viewContoller = AddTagViewController()
        let presenter = AddTagPresenter(view: viewContoller)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
