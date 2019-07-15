//
//  BaseViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/20.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    //MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    //MARK:- 定义变量
    var isLogin : Bool = UserAccountTool.shareIntance.isLogin
    
    //MARK:-系统回调函数
    override func loadView() {
        
        //判断加载哪一个view
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension BaseViewController {
    private func setupVisitorView() {
        
        view = visitorView
        
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        
    }
}


//MARK:- 事件监听
extension BaseViewController {
    @objc private func registerBtnClick() {
        print("注册")
    }
    
    @objc private func loginBtnClick() {
        
        //创建授权控制器
        let oauthVc = OAuthViewController()
       
        //弹出控制器
        present(oauthVc, animated: true, completion: nil)
        
    }
}
