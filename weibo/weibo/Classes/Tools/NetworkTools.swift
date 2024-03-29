//
//  NetworkTools.swift
//  AFNetworking的封装
//
//  Created by Mr wngkai on 2019/7/1.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import AFNetworking

class NetworkTools: AFHTTPSessionManager {
    
    enum RequestType : String {
        case GET = "GET"
        case POST = "POST"
    }
// let是线程安全的
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
}

//MARK:- 封装请求的方法
extension NetworkTools {
    func request(methodType : RequestType, urlString : String, parameters : [String : Any], finished : @escaping (Any?, Error?) -> ()) {
        
        //定义成功和失败的回调闭包
        let successCallBack = { (task : URLSessionDataTask, result : Any?) in
            finished(result, nil)
        }
        let failureCallBack = { (task : URLSessionDataTask?, error : Error) in
            finished(nil, error)
        }
        
        if methodType == .GET {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        
        
    }
}

//MARK:-请求AccessToken
extension NetworkTools {
    func loadAccessToken(code : String, finished : @escaping ([String : Any]?, Error?) -> ()) {
        //获取请求的urlstring
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_url, "code" : code]
        
        //发送请求
        AFHTTPSessionManager().responseSerializer = AFHTTPResponseSerializer()

        request(methodType: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any], error)
        }
    }
}


//MARK:-请求用户信息
extension NetworkTools {
    func loadUserInfo(access_token : String, uid : String, finished : @escaping ([String : Any]?, Error?) -> ()) {
        //获取请求的url
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        //获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        
        //请求数据
        request(methodType: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any], error)
        }
    }
}
//MARK:- 请求用户数据
extension NetworkTools {
    func loadStatuses(since_id : Int, max_id : Int, finished : @escaping ([[String : Any]]?, Error?) -> ()) {
        //获取请求的url
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //获取请求的参数
        let parameters = ["access_token" : (UserAccountTool.shareIntance.account?.access_token)!, "since_i d" : "\(since_id)", "max_id" : "\(max_id)"]
        
        //请求数据
        request(methodType: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            //获取字典的数据
            guard let resultDict = result as? [String : Any] else {
                finished(nil, error)
                return
            }
            
            //将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : Any]], error)
        }
        
    }
}


//MARK:- 发送微博
extension NetworkTools {
    func sendStatus(statusText : String, isSuccess : @escaping (Bool) -> ()) {
        //获取请求的url
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        
        //拿到请求的参数
        let parameters = ["access_token" : (UserAccountTool.shareIntance.account?.access_token)!, "status" : statusText]
        
        //请求数据
        request(methodType: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            print(result)
            if result != nil {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
        
    }
}
