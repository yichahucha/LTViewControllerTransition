//
//  PushAnimation.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/18.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class PushAnimation: LTTransitionManager {
    override func toAnimation(contextTransition: UIViewControllerContextTransitioning) {
        let containerView = contextTransition.containerView
        let fromVC = contextTransition.viewController(forKey: .from)
        let toVC = contextTransition.viewController(forKey: .to)
        let fromView = fromVC!.view
        let toView = toVC!.view
        let translation = containerView.frame.width
        let toViewTransform = CGAffineTransform(translationX: translation, y: 0)
        let fromViewTransform = CGAffineTransform(translationX: -translation, y: 0)
        containerView.addSubview(toView!)
        
        toView?.transform = toViewTransform
        UIView.animate(withDuration: duration, animations: {
            fromView?.transform = fromViewTransform
            toView?.transform = CGAffineTransform.identity
        }) { (finished) in
            fromView?.transform = CGAffineTransform.identity
            toView?.transform = CGAffineTransform.identity
            contextTransition.completeTransition(!contextTransition.transitionWasCancelled)
        }
    }
    
    override func backAnimation(contextTransition: UIViewControllerContextTransitioning) {
        let containerView = contextTransition.containerView
        let fromVC = contextTransition.viewController(forKey: .from)
        let toVC = contextTransition.viewController(forKey: .to)
        let fromView = fromVC!.view
        let toView = toVC!.view
        let translation = containerView.frame.width
        let toViewTransform = CGAffineTransform(translationX: -translation, y: 0)
        let fromViewTransform = CGAffineTransform(translationX: translation, y: 0)
        containerView.addSubview(toView!)
        
        toView?.transform = toViewTransform
        UIView.animate(withDuration: duration, animations: {
            fromView?.transform = fromViewTransform
            toView?.transform = CGAffineTransform.identity
        }) { (finished) in
            fromView?.transform = CGAffineTransform.identity
            toView?.transform = CGAffineTransform.identity
            contextTransition.completeTransition(!contextTransition.transitionWasCancelled)
        }
    }
}
