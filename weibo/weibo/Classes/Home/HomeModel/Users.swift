//
//  Users.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/18.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

@objcMembers class Users: NSObject {
    //MARK:- 属性
    var profile_image_url : String?     //用户头像
    var screen_name : String?           //用户昵称
    var verified_type : Int = -1        //用户认证类型
    var mbrank : Int = 0                //用户会员等级
    
    //MARK:-自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
