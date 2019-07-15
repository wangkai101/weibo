//
//  UserAccount.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/14.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

@objcMembers class UserAccount: NSObject, NSCoding {
    
    //授权AccessToken
    var access_token : String?
    //过期时间秒
    var expires_in : TimeInterval = 0.0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    //用户id
    var uid : String?
    //过期时间
    var expires_date : Date?
    //昵称
    var screen_name : String?
    //用户头像地址
    var avatar_large : String?
    
    
    
    //MARK:-自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    

    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    //MARK:-重写description属性
    override var description : String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
        
    }
    
    //MARK:- 归档 解档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
}
