//
//  SecondViewController.swift
//  ViewControllerTransition
//
//  Created by xulitao on 2018/4/17.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor
        title = "two"
        
        let dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        dismissButton.center = .init(x: view.center.x, y: view.center.y-50)
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.setTitleColor(.blue, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissAm), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        let pushButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        pushButton.center = .init(x: view.center.x, y: view.center.y)
        pushButton.setTitle("push", for: .normal)
        pushButton.setTitleColor(.blue, for: .normal)
        pushButton.addTarget(self, action: #selector(pushAm), for: .touchUpInside)
        view.addSubview(pushButton)
        
        lt_registerBackInteractiveTransition(direction: .left) {
            [weak self] in
            if let nav = self?.navigationController {
                nav.popViewController(animated: true)
            }else {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func pushAm() {
        let vc = SecondViewController()
        self.lt_pushViewControler(viewController: vc, transitionManager: PushAnimation())
    }
    
    @objc func dismissAm() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("消失")
    }
}
