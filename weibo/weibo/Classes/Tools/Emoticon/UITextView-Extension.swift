//
//  UITextView-Extension.swift
//  表情键盘
//
//  Created by Mr wngkai on 2019/7/27.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

extension UITextView {
    
    ///获取textview属性字符串，对应的表情字符串
    func getEmoticonString() -> String {
        //获取属性字符串
        let attrMsr = NSMutableAttributedString(attributedString: attributedText)
        
        //遍历属性字符串
        let range = NSRange(location: 0, length: attrMsr.length)
        attrMsr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key.attachment] as? EmoticonAttachment {
                attrMsr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        //获取字符串
        return attrMsr.string
    }
    
    
    
    ///给textview插入表情
    func insertEmoticon(emoticon : Emoticon) {
        //空白表情
        if emoticon.isEmpty {
            return
        }
        
        //删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
        //emoji表情
        if emoticon.emojiCode != nil {
            //获取光标所在位置: UITextRange
            let textRange = selectedTextRange!
            
            //替换emoji表情
            replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        //普通表情：图文混排
        //根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        //创建可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        //将图片属性字符串，替换到可变属性字符串的某一个位置
        //获取光标所在的位置
        let range = selectedRange
        
        //替换属性字符串
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        //显示属性字符串
        attributedText = attrMStr
        
        //将文字的大小重置
        self.font = font
        
        //将光标设置回原来位置+1
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
