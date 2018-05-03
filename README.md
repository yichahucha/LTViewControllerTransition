# LTViewControllerTransition

## 介绍
1.自定义转场动画，支持手势返回，与系统动画、手势不冲突，使用简单  
2.支持push、present

## 使用
新建继承自 `LTTransitionManager` 动画类，重新这两个方法，实现动画：
```Objective-C
//实现入场动画
func toAnimation(contextTransition:UIViewControllerContextTransitioning) {
        ...
}
//实现退场动画
func backAnimation(contextTransition:UIViewControllerContextTransitioning) {
        ...
}
```


使用 ViewController 的分类 `LTTransition` 提供的方法，进行 push、present，传入自定义的动画类
```Objective-C
//自定义动画转场 push
internal func lt_pushViewControler(viewController: UIViewController, transitionManager: LTTransitionManager)

//自定义动画转场 present
internal func lt_presentViewControler(viewController: UIViewController, transitionManager: LTTransitionManager)

//注册手势入场动画
internal func lt_registerToInteractiveTransition(direction: LTEdgePanGestureDirection, eventBlcok: @escaping (() -> Void))

//注册手势退场动画
internal func lt_registerBackInteractiveTransition(direction: LTEdgePanGestureDirection, eventBlcok: @escaping (() -> Void))
```

具体详见 demo...

## 演示
![](https://raw.githubusercontent.com/yichahucha/LTViewControllerTransition/master/2018-05-03%2010_55_51.gif)


