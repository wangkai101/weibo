//
//  Emoticon.swift
//  表情键盘
//
//  Created by Mr wngkai on 2019/7/26.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

@objcMembers class Emoticon : NSObject {
    //定义属性
    var code : String? {    //emoji的code
        didSet {
            guard let code = code else {
                return
            }
            
            //创建扫描器
            let scanner = Scanner(string: code)
            
            //调用方法，扫描出code的值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            //将值转成字符
            let c = Character(UnicodeScalar(value)!)
            
            //将字符转成字符串
            emojiCode = String(c)
        }
    }
    var png : String? {     //普通表情对应的图片名字
        didSet {
            guard let png = png else {
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs : String?       //普通表情对应的文字
    
    //数据的处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    init (isRemove : Bool) {
        self.isRemove = isRemove
    }
    
    init (isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode", "pngPath", "chs"]).description
    }
}
