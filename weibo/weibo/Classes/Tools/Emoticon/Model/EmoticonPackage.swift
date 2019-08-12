//
//  EmoticonPackage.swift
//  表情键盘
//
//  Created by Mr wngkai on 2019/7/26.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class EmoticonPackage : NSObject {
    var emoticons : [Emoticon] = [Emoticon]()
    
    init(id : String) {
        super.init()
        
        //最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        //根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        //根据plist文件的路径读取数据
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        
        //遍历数组
        var index = 0
        for  var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict: dict))
            index += 1
            
            if index == 20 {
                //添加删除的表情
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        
        //添加空白表情
        addEmptyEmoticon(isRecently: false)
    }
    
    private func addEmptyEmoticon(isRecently : Bool) {
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        
        emoticons.append(Emoticon(isRemove: true))
    }
        
    

}
