//
//  PhotoBrowserController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/27.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {
    
    //MARK:- 定义属性
    var indexPath : NSIndexPath
    var picURLs : [URL]
    
    //MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    private lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    private lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")

    
    //MARK:- 自定义构造函数
    init(indexPath : NSIndexPath, picURLs : [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
    }
}

//MARK:- 设置ui
extension PhotoBrowserController {
    private func setupUI() {
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        view.addSubview(closeBtn)

        //设置frame
        collectionView.frame = view.bounds
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
            make.size.equalTo(closeBtn.snp_size)
        }
        
        //设置collectionView的属性
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        //滚动到对应的图片
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
        
        //监听两个按钮的点击
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)

    }
}

//MARK:- 事件监听函数
extension PhotoBrowserController {
    @objc func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnClick() {
        //获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        //将image对象保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc private func saveImage(image : UIImage, didFinishSavingWithError : Error?, contextInfo : Any) {
        var shouInfo = ""
        if didFinishSavingWithError != nil {
            shouInfo = "保存失败"
        } else {
            shouInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: shouInfo)
    }
}

//MARK:- 设置collectionView的数据源,代理
extension PhotoBrowserController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        
        return cell
        
    }
 
}

//MARK:- PhotoBrowserViewCell的代理方法
extension PhotoBrowserController : PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //设置itemsize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //设置collectionview的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
