//
//  PresentAnimation.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/18.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

/*
 使用 Core Animation 来实现转场，在非交互转场时没有问题，在交互转场下会有点瑕疵，要达到完美要麻烦一点。
 
 交互转场必须用 UIView Animtion API 才能实现完美的控制，其实并不是 Core Animation 做不到，
 毕竟 UIView Animation 是基于 Core Animation 的，那为什么苹果的工程师在 WWDC 上说必须使用前者呢。
 因为使用 Core Animation 来实现成本高啊，在转场中做到与 UIView Animation 同样的事情配置麻烦些，估计很多人都不会配置，
 而且在交互转场中会比较麻烦，本来转场 API 已经分裂得够复杂了，老老实实用高级 API 吧。
 
 上面说的 UIView Animation API 指的是带 completion 闭包的 API，使用 Core Animation 来实现这个闭包需要配置
 CATransaction，这就是麻烦的地方，还是用高级的 API 吧。
 
 在自定义的容器控制器转场中，交互部分需要我们自己动手实现控制动画的进度，此时 使用 Core Animation 或 UIView Animation
 区别不大，重点在于在手势中如何控制动画。
 */

class PresentAnimation: LTTransitionManager {
    override func toAnimation(contextTransition: UIViewControllerContextTransitioning) {
        let containerView = contextTransition.containerView
        let fromVC = contextTransition.viewController(forKey: .from)
        let toVC = contextTransition.viewController(forKey: .to)
        let fromView = fromVC!.view
        let toView = toVC!.view
        let translation = containerView.frame.height
        let toViewTransform = CGAffineTransform(translationX: 0, y: translation)
        let fromViewTransform = CGAffineTransform(translationX: 0, y: -translation)
        containerView.addSubview(toView!)
        
        //toView从屏幕底部开始
        toView?.transform = toViewTransform
        UIView.animate(withDuration: duration, animations: {
            //fromView从原始位置移到屏幕最上方
            fromView?.transform = fromViewTransform
            //toView从屏幕底部向上移动
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
        let translation = containerView.frame.height
        let toViewTransform = CGAffineTransform(translationX: 0, y: -translation)
        let fromViewTransform = CGAffineTransform(translationX: 0, y: translation)
        containerView.insertSubview(toView!, at: 0)
        
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
