//
//  MainViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/19.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    //MARK:- 懒加载属性
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupComposeBtn()
    }
}


extension MainViewController {
    /// 设置发布按钮
    private func setupComposeBtn() {
        //将按钮添加到tabbar中
        tabBar.addSubview(composeBtn)
        
        //设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //监听发布按钮的点击
        composeBtn.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)    }
}


//MARK:- 事件监听
extension MainViewController {
    @objc func composeBtnClick() {
        print("12")
    }
}
