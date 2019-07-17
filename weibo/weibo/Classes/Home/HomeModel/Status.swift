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
    var created_at : String? {                 // 微博创建时间
        didSet {
            //nil值校验
            guard let created_at = created_at else {
                return
            }
            
            //对时间进行处理
            createAtText = Date.createDateString(createAtStr: created_at)
        }
    }
    var source : String? {                     // 微博来源
        didSet {
            //nil值校验
            guard let source = source, source != "" else {
                return
            }
            
            //对来源的字符串进行处理
               //获取起始位置和截取的长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
               //截取字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
    }
    var text : String?                         // 微博正文
    var mid : Int = 0                          // 微博id
    
    //MARK:- 对数据处理的属性
    var sourceText : String?
    var createAtText : String?
    
    
    //MARK:- 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
