//
//  StatusViewModel.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/18.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    //MARK:-定义属性
    var status : Status?
    
    //MARK:- 对数据处理的属性
    var sourceText : String?            //处理来源
    var createAtText : String?          //处理创建时间
    var verifiedImage : UIImage?        //处理用户认证图标
    var vipImage : UIImage?             //处理用户会员等级
    var profileURL : URL?               //处理用户头像的地址
    var picURLs : [URL] = [URL]()       //处理微博配图
    
    
    //MARK:-自定义构造函数
    init(status: Status) {
        self.status = status
        
        //对来源处理
        if let source = status.source, source != "" {
            //获取起始位置和截取的长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            //截取字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        //对时间处理
        if let created_at = status.created_at {
          createAtText = Date.createDateString(createAtStr: created_at)
        }
        
        //处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        //处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0, mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        //处理用户头像
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLString)
        
        //处理微博配图
        if let picURLDicts = status.pic_urls {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(URL(string: picURLString)!)
            }
        }
    }
}
