//
//  AddSearchTagBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import Foundation

final class AddSearchTagBuilder {
    static func build() -> AddSearchTagViewController {
        let viewContoller = AddSearchTagViewController()
        let presenter = AddSearchTagPresenter(view: viewContoller)
        
        viewContoller.presenter = presenter
        
        return viewContoller
    }
}
