//
//  LTTransitionManager.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/16.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class LTTransitionManager: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    //过渡时间 默认0.5秒
    var duration = 0.5
    var operation:UINavigationControllerOperation?
    //入场手势
    var toInteractiveTransition:LTInteractiveTransition?
    //退场手势
    var backInteractiveTransition:LTInteractiveTransition?
    //入场动画
    var toTransitionAnimation: LTTransitionAnimation {
        let animation = LTTransitionAnimation(duration: duration)
        animation.animationBlock = {(transitionContext:UIViewControllerContextTransitioning) -> Void in
            self.toAnimation(contextTransition: transitionContext)
        }
        return animation
    }
    //退场动画
    var backTransitionAnimation: LTTransitionAnimation {
        let animation = LTTransitionAnimation(duration: duration)
        animation.animationBlock =
            {(transitionContext:UIViewControllerContextTransitioning) -> Void in
                self.backAnimation(contextTransition: transitionContext)
        }
        return animation
    }
    
    
    func toAnimation(contextTransition:UIViewControllerContextTransitioning) {
        //子类重写动画
    }
    func backAnimation(contextTransition:UIViewControllerContextTransitioning) {
        //子类重写动画
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    //非手势转场 present
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return toTransitionAnimation
    }
    //非手势转场 dismiss
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return backTransitionAnimation
    }
    //手势转场 present
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return toInteractiveTransition
    }
    //手势转场 dismiss
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return backInteractiveTransition
    }
    
    // MARK: UINavigationControllerDelegate
    //非手势转场 push or pop
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation
        if operation == .push {
            return toTransitionAnimation
        }else if operation == .pop {
            return backTransitionAnimation
        }else {
            return nil
        }
    }
    //手势转场 push or pop
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.operation == .push {
            if toInteractiveTransition != nil {
                return toInteractiveTransition!.isPanGestureInteration ? toInteractiveTransition : nil
            }else {
                return nil
            }
        }else {
            
            if backInteractiveTransition != nil {
                return backInteractiveTransition!.isPanGestureInteration ? backInteractiveTransition : nil
            }else {
                return nil
            }
        }
    }
}
