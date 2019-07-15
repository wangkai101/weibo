//
//  VisitorView.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/20.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class VisitorView: UIView {

  //MARK:- 提供快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }

    //MARK:- l控件属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    //自定义函数
    func setupvisitorViewInfo(iconName : String, title : String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
 
    func addRotationAnimal() {
        let rotationAnimal = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotationAnimal.fromValue = 0
        rotationAnimal.toValue = Double.pi * 2
        rotationAnimal.repeatCount = MAXFLOAT
        rotationAnimal.duration = 12
        rotationAnimal.isRemovedOnCompletion = false
        
        rotationView.layer.add(rotationAnimal, forKey: nil)
    }
   
    
}
