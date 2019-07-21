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
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    //MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    
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
            
            //计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            //将picView数据传给picView
            picView.picURLs = viewModel.picURLs
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.height - 2 * edgeMargin
        
        //取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }


}


//MARK:- 计算方法
extension HomeViewCell {
    private func calculatePicViewSize(count : Int) -> CGSize {
        //没有配图
        if count == 0 {
            return CGSize.zero
        }
        //计算出来imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        //四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        //其它张配图
            //计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
            //计算高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
            //计算宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
        }
}
