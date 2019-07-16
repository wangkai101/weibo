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
    
    //MARK:- 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
