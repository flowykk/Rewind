//
//  LoadingView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import UIKit

class LoadingView {
    static func show(in viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        let loadingView = UIView(frame: viewController.view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        viewController.view.addSubview(loadingView)
        loadingView.isUserInteractionEnabled = true
        viewController.view.isUserInteractionEnabled = false
    }
    
    static func hide(from viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        viewController.view.subviews.first(where: { $0.backgroundColor == UIColor(white: 0, alpha: 0.3) })?.removeFromSuperview()
        viewController.view.isUserInteractionEnabled = true
    }
}
