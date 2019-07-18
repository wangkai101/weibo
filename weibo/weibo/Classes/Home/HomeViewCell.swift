//
//  HomeViewCell.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/18.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15

class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    //MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    //MARK:-自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            //nil值校验
            guard let viewModel = viewModel else { return  }
            
            //d设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            //设置认证图标
            verifiedView.image = viewModel.verifiedImage
            
            //设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            
            //会员图标
            vipView.image = viewModel.vipImage
            
            //设置时间label
            timeLabel.text = viewModel.createAtText
            
            //设置来源
            sourceLabel.text = viewModel.sourceText
            
            //设置正文
            contentLabel.text = viewModel.status?.text
            
            //设置昵称文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.height - 2 * edgeMargin
    }


}
