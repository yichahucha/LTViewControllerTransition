//
//  CircleSpreadAnimation.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/18.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class CircleSpreadAnimation: LTTransitionManager, CAAnimationDelegate {
    
    var centerPoint:CGPoint = CGPoint(x: 0, y: 0)//中心点
    var startRadius:CGFloat = 1.0 //起始半径
    var contextTransition:UIViewControllerContextTransitioning?
    
    init(point: CGPoint, radius: CGFloat) {
        centerPoint = point
        startRadius = radius
    }
    
    override func toAnimation(contextTransition: UIViewControllerContextTransitioning) {
        self.contextTransition = contextTransition
        
        //获取目标动画 视图
        let containerView = contextTransition.containerView
        let toVC = contextTransition.viewController(forKey: .to)
        let toView = toVC!.view
        containerView.addSubview(toView!)
        
        //起始路径
        let startPath = UIBezierPath(arcCenter: centerPoint, radius: startRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        //获取动画最大半径
        let x = centerPoint.x
        let y = centerPoint.y
        let radius_x = fmax(x, containerView.frame.size.width - x)
        let radius_y = fmax(y, containerView.frame.size.height - y)
        let endRadius = sqrt(pow(radius_x, 2) + pow(radius_y, 2))
        
        //结束路径
        let endPath = UIBezierPath(arcCenter: centerPoint, radius: CGFloat(endRadius), startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        //遮罩
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = endPath.cgPath
        toView?.layer.mask = shapeLayer
        
        //开始动画
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath.cgPath
        animation.duration = duration
        animation.delegate = self
        shapeLayer.add(animation, forKey: nil)
        
    }
    
    override func backAnimation(contextTransition: UIViewControllerContextTransitioning) {
        self.contextTransition = contextTransition
        
        let containerView = contextTransition.containerView
        let fromVC = contextTransition.viewController(forKey: .from)
        let toVC = contextTransition.viewController(forKey: .to)
        let fromView = fromVC!.view
        let toView = toVC!.view
        containerView.insertSubview(toView!, at: 0)
        
        let fromMaskLayer = fromView!.layer.mask as! CAShapeLayer
        let startPath = UIBezierPath(cgPath: fromMaskLayer.path!)
        let endPath = UIBezierPath(arcCenter: centerPoint, radius: startRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        //开始动画
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = duration
        animation.delegate = self
        fromMaskLayer.add(animation, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.contextTransition!.completeTransition(true)
    }
}
