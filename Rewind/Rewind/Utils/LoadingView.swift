//
//  LoadingView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import UIKit

class LoadingView {
    static func show(in viewController: UIViewController?, backgroundColor: UIColor = UIColor(white: 0, alpha: 0.3)) {
        guard let viewController = viewController else { return }
        
        let loadingView = UIView(frame: viewController.view.bounds)
        loadingView.backgroundColor = backgroundColor
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        viewController.view.addSubview(loadingView)
        loadingView.tag = 777
        loadingView.isUserInteractionEnabled = true
        viewController.view.isUserInteractionEnabled = false
    }
    
    static func hide(from viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        viewController.view.subviews.forEach { subview in
            if subview.tag == 777 {
                subview.removeFromSuperview()
            }
        }
        viewController.view.isUserInteractionEnabled = true
    }
}
