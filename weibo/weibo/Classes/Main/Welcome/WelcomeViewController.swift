//
//  WelcomeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/15.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置头像
        let profileURLString = UserAccountTool.shareIntance.account?.avatar_large
        let url = URL(string: profileURLString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        
       //改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 250
        
        //执行动画
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }


}
