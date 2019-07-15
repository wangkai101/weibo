//
//  PoppresentationController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/27.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class PoppresentationController: UIPresentationController {
    //MARK:-对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    //MARK:- 懒加载属性
    private lazy var coverView : UIView = UIView()
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //设置弹出view的尺寸
        presentedView?.frame = presentedFrame
        
        //添加蒙版
        setupCoverView()
    }
}

//MARK:- 设置ui相关
extension PoppresentationController {
    private func setupCoverView() {
       //添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        //设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        coverView.frame = containerView!.bounds
        
        //添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(coverViewClick))
        coverView.addGestureRecognizer(tapGes)
        
    }
}

//MARK:- 事件监听
extension PoppresentationController {
    @objc private func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
