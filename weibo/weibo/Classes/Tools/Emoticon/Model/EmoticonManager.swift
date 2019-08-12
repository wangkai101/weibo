//
//  EmoticonManager.swift
//  表情键盘
//
//  Created by Mr wngkai on 2019/7/26.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class EmoticonManager {
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        //添加最近表情包
        packages.append(EmoticonPackage(id: ""))
        
        //添加默认表情包
        packages.append(EmoticonPackage(id: "com.sina.default"))
        
        //添加emoji表情包
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        
        //添加浪小花表情包
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
    

}
