//
//  HomeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/20.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    
//MARK:- 懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
    private lazy var popoverAnimator : Popoveranimator = Popoveranimator {[weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //没有登录时设置的内容
        visitorView.addRotationAnimal()
        if !isLogin {
            return
        }
       
        //设置导航栏的内容
        setupNavigationBar()
    }
}

//MARK:- 设置UI界面
extension HomeViewController {
    private func setupNavigationBar() {
        //设置左侧Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        //设置右侧Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //设置btitleView
        titleBtn.setTitle("wanger", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn

    }
}


//MARK:- 事件监听的函数
extension HomeViewController {
    @objc private func titleBtnClick() {
        titleBtn.isSelected = !titleBtn.isSelected
        
        //创建弹出的控制器
        let popoverVc = PopViewController()
        
        //设置modal的弹出样式(如果不设置会使弹出前的画面默认移除)
        popoverVc.modalPresentationStyle = .custom
        
        //设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 100, width: 180, height: 250)
        
        //弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}

