//
//  Status.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/16.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

@objcMembers class Status: NSObject {
    //MARK:-属性
    var created_at : String?                   // 微博创建时间
    var source : String?                       // 微博来源
    var text : String?                         // 微博正文
    var mid : Int = 0                          // 微博id
    var user : Users?                          //微博对应的用户
    var pic_urls : [[String : String]]?        //微博的配图
    var retweeted_status : Status?             //对应转发的微博
    
    
    
    
    
    //MARK:- 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
        //将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : Any] {
            user = Users(dict: userDict)
        }
        
        //将转发微博字典转成转发微博的模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : Any] {
            retweeted_status = Status(dict: retweetedStatusDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
