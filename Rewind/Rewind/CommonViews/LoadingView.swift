//
//  LoadingView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import UIKit

final class LoadingView {
    static func show(inVC viewController: UIViewController?, backgroundColor: UIColor = .systemBackground) {
        guard let viewController = viewController else { return }
        
        let loadingView = UIView(frame: viewController.view.bounds)
        loadingView.backgroundColor = backgroundColor
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        viewController.view.addSubview(loadingView)
        viewController.view.bringSubviewToFront(loadingView)
        
        loadingView.tag = 777
        loadingView.isUserInteractionEnabled = true
        
        viewController.view.isUserInteractionEnabled = false
    }
    
    static func hide(fromVC viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        viewController.view.subviews.forEach { subview in
            if subview.tag == 777 {
                subview.removeFromSuperview()
            }
        }
        
        viewController.view.isUserInteractionEnabled = true
    }
    
    static func show(inView view: UIView?, backgroundColor: UIColor = .systemBackground, indicatorStyle: UIActivityIndicatorView.Style = .large) {
        guard let view = view else { return }
        
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = backgroundColor
        
        let activityIndicator = UIActivityIndicatorView(style: indicatorStyle)
        activityIndicator.color = .black
        activityIndicator.center = loadingView.center
        
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        loadingView.tag = 777
        loadingView.isUserInteractionEnabled = true
        
        view.isUserInteractionEnabled = false
    }
    
    static func hide(fromView view: UIView?) {
        guard let view = view else { return }
        
        view.subviews.forEach { subview in
            if subview.tag == 777 {
                subview.removeFromSuperview()
            }
        }
        
        view.isUserInteractionEnabled = true
    }
}
