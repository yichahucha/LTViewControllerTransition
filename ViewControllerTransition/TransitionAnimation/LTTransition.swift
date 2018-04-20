//
//  LTTransition.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/17.
//  Copyright © 2018年 swift. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //key
    private struct AssociaKey{
        static var kInteractiveTransitionKey = "kInteractiveTransitionKey"
        static var kAnimationManagerKey = "kAnimationManagerKey"
    }
    
    //动态添加手势属性
    var interactiveTransition:LTInteractiveTransition? {
        get {
            return objc_getAssociatedObject(self, &AssociaKey.kInteractiveTransitionKey) as? LTInteractiveTransition
        }
        set {
            objc_setAssociatedObject(self, &AssociaKey.kInteractiveTransitionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    //自定义动画转场 push
    func lt_pushViewControler(viewController: UIViewController, transitionManager: LTTransitionManager) {
        if navigationController != nil {
            
            UIViewController.initializeMethod()
            objc_setAssociatedObject(viewController, &AssociaKey.kAnimationManagerKey, transitionManager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.delegate = transitionManager
            if interactiveTransition != nil {
                transitionManager.toInteractiveTransition = interactiveTransition
            }
            navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    //自定义动画转场 present
    func lt_presentViewControler(viewController: UIViewController, transitionManager: LTTransitionManager) {
        viewController.transitioningDelegate = transitionManager
        if interactiveTransition != nil {
            transitionManager.toInteractiveTransition = interactiveTransition
        }
        objc_setAssociatedObject(viewController, &AssociaKey.kAnimationManagerKey, transitionManager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.present(viewController, animated: true, completion: nil)
    }
    
    //注册手势入场动画
    func lt_registerToInteractiveTransition(direction: LTEdgePanGestureDirection, eventBlcok:@escaping (()->Void)) {
        let transition =  LTInteractiveTransition()
        transition.enventBolck = eventBlcok
        transition.addEdgePageGestureWithView(view: self.view, direction: direction)
        interactiveTransition = transition
    }
    
    //注册手势退场动画
    func lt_registerBackInteractiveTransition(direction: LTEdgePanGestureDirection, eventBlcok:@escaping (()->Void)) {
        let transition =  LTInteractiveTransition()
        transition.enventBolck = eventBlcok
        transition.addEdgePageGestureWithView(view: self.view, direction: direction)
        let animator = objc_getAssociatedObject(self, &AssociaKey.kAnimationManagerKey) as? LTTransitionManager
        if animator != nil {
            animator!.backInteractiveTransition = transition
        }
    }
    
    //导航控制器的代理每次都会指向最后一个控制器，当最后一个控制器消失，导航控制器delegate就会变为nil，默认使用系统动画，所以在这里每次重新设置一下代理
    @objc func lt_viewDidAppear(animated: Bool) {
        let animator = objc_getAssociatedObject(self, &AssociaKey.kAnimationManagerKey) as? LTTransitionManager
        if let an = animator {
            navigationController?.delegate = an
        }
        self.lt_viewDidAppear(animated: animated)
    }
    
    //交换方法
    public class func initializeMethod() {
        struct Static {
            static var token = NSUUID().uuidString
        }
        DispatchQueue.once(token: Static.token) {
            let originalSelector = #selector(UIViewController.viewDidAppear(_:))
            let swizzledSelector = #selector(UIViewController.lt_viewDidAppear(animated:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
}

extension DispatchQueue {
    private static var onceTracker = [String]()
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}
