//
//  Date-Extension.swift
//  时间处理
//
//  Created by Mr wngkai on 2019/7/17.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import Foundation

extension Date {
    static func createDateString(createAtStr : String) -> String {
        //创建时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        
        //把字符串时间转成NSDate类型
        guard let createDate = fmt.date(from: createAtStr) else {
            return ""
        }
        
        //创建当前时间
        let nowDate = Date()
        
        //计算创建时间和当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        //时间间隔处理
        //显示刚刚
        if interval < 60 {
            return "刚刚"
        }
        //59分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        //24小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        //创建日历对象
        let calendar = Calendar.current
        
        //处理昨天数据
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        //处理一年之内
        let cmps = calendar.dateComponents([.year], from: createDate, to: nowDate)
        if cmps.year! < 1 {
            if interval > 60 * 60 * 24 {
                fmt.dateFormat = "MM-dd HH:mm"
                let timeStr = fmt.string(from: createDate)
                return timeStr
            }
        }
        
        //超过一年
        if cmps.year! >= 1 {
            fmt.dateFormat = "yyyy-MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
    return ""
}
}
