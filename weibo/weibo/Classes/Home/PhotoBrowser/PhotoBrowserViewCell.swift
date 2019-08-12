//
//  PhotoBrowserViewCell.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/27.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowserViewCell: UICollectionViewCell {
    //MARK:- 定义属性
    var picURL : URL? {
        didSet {
            setupContent(picURL: picURL)
        }
    }
    
    weak var delegate : PhotoBrowserViewCellDelegate?
    
    
    //MARK:- 懒加载属性
    private lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    private lazy var progressView : ProgressView = ProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:-设置ui界面内容
extension PhotoBrowserViewCell {
    private func setupUI() {
        //添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(progressView)
        
        //设置frame
        scrollView.frame = contentView.bounds
        scrollView.showsVerticalScrollIndicator = false
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        //设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        //监听imageView的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
    }
}

//MARK:- 事件监听
extension PhotoBrowserViewCell {
    @objc private  func imageViewClick() {
        delegate?.imageViewClick()
    }
}

//MARK:- 设置内容
extension PhotoBrowserViewCell {
    private func setupContent(picURL : URL?) {
        //nil值校验
        guard let picURL = picURL else {
            return
        }
        
        //取出image对象
        let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: picURL.absoluteString)
        
        //计算imageview的frame
        let width = UIScreen.main.bounds.width
        let height = width / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        
        //设置imageview的图片
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigURL(smallURL: picURL), placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        
        //设置scrollview的contentSize
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    private func getBigURL(smallURL : URL) -> URL {
        let smallURLString = smallURL.absoluteString
        let bigURLString = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return URL(string: bigURLString)!
    }
}
