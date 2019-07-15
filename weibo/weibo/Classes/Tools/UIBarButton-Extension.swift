//
//  UIBarButton-Extension.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/25.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName : String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
    }
}
