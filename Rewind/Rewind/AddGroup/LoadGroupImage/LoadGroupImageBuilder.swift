//
//  LoadGroupImageBuilder.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import Foundation

final class LoadGroupImageBuilder {
    static func build() -> LoadGroupImageViewController {
        let viewController = LoadGroupImageViewController()
        let presenter = LoadGroupImagePresenter(view: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
