//
//  LTLInteractiveTransition.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/16.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

enum LTEdgePanGestureDirection {
    case top
    case left
    case bottom
    case right
}

class LTInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    //交互状态
    var isPanGestureInteration: Bool = false
    //手势开始的操作
    var enventBolck: (()->Void)?
    
    //添加侧滑手势
    func addEdgePageGestureWithView(view:UIView, direction:LTEdgePanGestureDirection) {
        
        let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleRecognizer(recognizer:)))
        view.addGestureRecognizer(panGesture)
        
        switch direction {
        case .top:
            panGesture.edges = .top
        case .left:
            panGesture.edges = .left
        case .bottom:
            panGesture.edges = .bottom
        case .right:
            panGesture.edges = .right
        }
    }
    
    @objc func handleRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        //计算滑动的百分比，也就是手指滑动的距离
        var progress:CGFloat = 0.0
        switch recognizer.edges {
        case .top, .bottom:
            progress = fabs(recognizer.translation(in: recognizer.view).y)/recognizer.view!.bounds.size.height
        case .left, .right:
            progress = fabs(recognizer.translation(in: recognizer.view).x)/recognizer.view!.bounds.size.width
        default: break
        }
        progress = min(1.0, max(0.0, progress))
        
        switch recognizer.state {
        case .began:
            isPanGestureInteration = true
            //触发时间 执行 push pop present dismiss
            if enventBolck != nil {
                enventBolck!()
            }
        case .changed:
            //更新进度
            self.update(progress)
        case .ended, .cancelled:
            isPanGestureInteration = false
            //设置过渡值
            if progress > 0.5 {
                //完成转场
                self.finish()
            }else {
                //取消转场
                self.cancel()
            }
        default:
            isPanGestureInteration = false
        }
    }
}
