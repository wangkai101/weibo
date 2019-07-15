//
//  OAuthViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/1.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    @IBAction func closeItemClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func filllItemClick(_ sender: Any) {
        let jsCode = "document.getElementById('userId').value='15662468072';document.getElementById('passwd').value='wangkai1996512';"
        
        webView.evaluateJavaScript(jsCode, completionHandler: nil)
    }
    
    //懒加载属性
    private lazy var webView : WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置web组件
        setupWebView()
            }
}

//MARK:- 设置webview
extension OAuthViewController {
    private func setupWebView() {
        webView = WKWebView( frame: CGRect(x:0, y:64,width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        //获取登录页面的urlstring
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_url)"
        
        //创建对应url
        guard let url = URL(string: urlString) else {
            return
        }
        
        //创建urlrequest对象
        let request = URLRequest(url: url)
        
        //加载request对象
        webView.load(request)
        webView.navigationDelegate = self
        
        view.addSubview(webView)
    }
}

//MARK:- 实现WKWebView的代理
extension OAuthViewController : WKNavigationDelegate {
    //webView开始加载网页
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    //网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
    }
    
    //网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
    
   

     // 在发送请求前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //获取加载网页的url
        let url = webView.url!

        //获取url中的字符串
        let urlString = url.absoluteString

        //判断该字符串中是否包含code
        var code = ""
        if urlString.contains("code=") {
           
            //将code截取出来
            code = urlString.components(separatedBy: "code=").last!

            //print(code)
            
            decisionHandler(WKNavigationActionPolicy.cancel)
           //请求accessToken
            loadAccessToken(code: code)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
       
        
        
       }

}

//请求数据
extension OAuthViewController {
    //请求AccessToken
    private func loadAccessToken(code : String) {
        
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            //错误校验
            if error != nil {
                print(error!)
                return
            }

            //拿到结果
            guard let accountDict = result else {
                print("没有获取到授权后的数据")
                return
            }
            
            //将字典转成模型对象   
            let account = UserAccount(dict: accountDict)
            
            //请求用户信息
            self.loadUserInfo(account: account)
            
        }
        
    }
    
    //请求用户信息
    private func loadUserInfo(account : UserAccount) {
        //获取accesstoken
        guard let accessToken = account.access_token else {
            return
        }
        //获取uid
        guard let uid = account.uid else {
            return
        }
        //请求数据
        NetworkTools.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) { (result, error) in
            //错误校验
            if error != nil {
                print(error!)
                return
            }
            //拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            //从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            //将account对象保存（用归档解档）
              //获取沙盒路径
            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
            print(accountPath)
            
              //保存对象
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)

          
            //将account对象设置到单例对象中
            UserAccountTool.shareIntance.account = account
            
            //显示欢迎界面
               //退出当前控制器
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
            
        }
    }
}

