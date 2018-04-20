//
//  GLTransitionAnimation.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/16.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class LTTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval?
    var animationBlock: ((_ transitionContext:UIViewControllerContextTransitioning) -> Void)?
    
    init(duration: TimeInterval) {
        animationDuration = duration
    }
    
    //转场时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration!
    }
    //转场动画实现
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if animationBlock != nil {
            animationBlock!(transitionContext)
        }
    }
}
