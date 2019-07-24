//
//  ComposeTextView.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/24.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    
    lazy var placeholderLaber : UILabel = UILabel()

    //MARK:-构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        setupUI()
    }

}


//设置ui
extension ComposeTextView {
    private func setupUI() {
        addSubview(placeholderLaber)
        
        placeholderLaber.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        placeholderLaber.textColor = UIColor.lightGray
        placeholderLaber.font = font
        
        placeholderLaber.text = "分享新鲜事..."
        
        textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 0, right: 7)

    }
}


