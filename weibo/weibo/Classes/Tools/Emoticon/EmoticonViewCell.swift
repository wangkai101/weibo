//
//  EmoticonViewCell.swift
//  表情键盘
//
//  Created by Mr wngkai on 2019/7/26.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    //MARK:-懒加载属性
    private lazy var emoticonBtn : UIButton = UIButton()
    
    //MARK:- 定义属性
    var emoticon : Emoticon? {
        didSet {
        guard let emoticon = emoticon else {
            return
        }
        //设置emoticonBtn的内容
        emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
        emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
        //设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
            
        //设置空白按钮
            if emoticon.isEmpty {
                emoticonBtn.setImage(UIImage(named: ""), for: .normal)
            }
    }
}
    //MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- 设置ui界面
extension EmoticonViewCell {
    private func setupUI() {
        //添加子控件
        contentView.addSubview(emoticonBtn)
        
        //设置btn的frame
        emoticonBtn.frame = contentView.bounds
        
        //设置btn属性
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
