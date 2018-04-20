//
//  ViewController.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/16.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor
        title = "one"
        
        let pushButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        pushButton.center = .init(x: view.center.x, y: view.center.y-50)
        pushButton.setTitle("push", for: .normal)
        pushButton.setTitleColor(.blue, for: .normal)
        pushButton.addTarget(self, action: #selector(pushAm), for: .touchUpInside)
        view.addSubview(pushButton)
        
        let presentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        presentButton.center = .init(x: view.center.x, y: view.center.y)
        presentButton.setTitle("present", for: .normal)
        presentButton.setTitleColor(.green, for: .normal)
        presentButton.addTarget(self, action: #selector(presentAm), for: .touchUpInside)
        view.addSubview(presentButton)
        
        let spreadButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        spreadButton.center = .init(x: view.center.x, y: view.center.y+50)
        spreadButton.setTitle("spread", for: .normal)
//        spreadButton.titleLabel?.font = .systemFont(ofSize: 10)
        spreadButton.setTitleColor(.orange, for: .normal)
        spreadButton.backgroundColor = .yellow
        spreadButton.addTarget(self, action: #selector(spreadAm(button:)), for: .touchUpInside)
        spreadButton.layer.masksToBounds = true
        spreadButton.layer.cornerRadius = spreadButton.frame.size.height/2
        view.addSubview(spreadButton)
    }
    
    @objc func pushAm() {
        let vc = SecondViewController()
        self.lt_pushViewControler(viewController: vc, transitionManager: PushAnimation())
    }
    
    @objc func presentAm() {
        let vc = SecondViewController()
        self.lt_presentViewControler(viewController: vc, transitionManager: PresentAnimation())
    }
    
    @objc func spreadAm(button: UIButton) {
        let vc = SecondViewController()
        let animation = CircleSpreadAnimation(point: button.center, radius: button.frame.size.width/2)
        self.lt_presentViewControler(viewController: vc, transitionManager: animation)
    }

}

extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

