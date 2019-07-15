//
//  UserAccountTool.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/15.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class UserAccountTool {
    //MARK:-将类设计成单例
    static let shareIntance : UserAccountTool = UserAccountTool()
    //MARK:-定义属性
    var account : UserAccount?
    
    //MARK:-计算属性
    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print(accountPath)
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }
    
    var isLogin : Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else { return false }
        
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    
    //MARK:- 重写init()函数
    init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}
