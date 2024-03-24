//
//  AnimationController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import UIKit

// MARK: - PushTransitioning
final class PushTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.325
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        toVC.view.frame = finalFrame.offsetBy(dx: -finalFrame.width, dy: 0)
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFrame.offsetBy(dx: finalFrame.width / 3, dy: 0)
            toVC.view.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

// MARK: - PopTransitioning
final class PopTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        toVC.view.frame = finalFrame.offsetBy(dx: finalFrame.width / 3, dy: 0)
        fromVC.view.frame = finalFrame
        
        containerView.addSubview(toVC.view)
        containerView.sendSubviewToBack(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFrame.offsetBy(dx: -finalFrame.width, dy: 0)
            toVC.view.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

// MARK: - PushFromBottomTransitioning
final class PushFromBottomTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        
        toView.frame = CGRect(x: 0, y: finalFrame.height, width: finalFrame.width, height: finalFrame.height)
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

// MARK: - PopToBottomTransitioning
final class PopToBottomTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        
        toView.frame = finalFrame
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
            toView.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
