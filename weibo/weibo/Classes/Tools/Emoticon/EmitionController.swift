//
//  EmitionController.swift
//  表情键盘
//
//  Created by Mr wngkai on 2019/7/25.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

private let EmotionCell = "EmotionCell"

class EmitionController: UIViewController {
    
    var emoticonCallBack : (Emoticon) -> ()
    
    //懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()
    
    //MARK:- 自定义构造函数
    init(emoticonCallBack : @escaping (Emoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
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
extension EmitionController {
    private func setupUI() {
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.lightGray
        toolBar.backgroundColor = UIColor.blue
        
        //设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar, "cView" : collectionView]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        
        view.addConstraints(cons)
        
        //设置collectionView
        prepareForCollectionView()
        
        //设置toolBar
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        //注册cell，设置数据源
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmotionCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
        let titles = ["最近","默认","emoji","浪小花"]
        var index = 0
        var tempItems = [UIBarButtonItem]()
        
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        toolBar.items = tempItems
    }
    
    @objc func itemClick(item : UIBarButtonItem) {
        //获取点击的item的tag
        let tag = item.tag
        
        //根据tag获取当前组
        let indexPath = IndexPath(item: 0, section: tag)
        
        //滚动到对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        
    }
}

//MARK:- 遵守collectionView数据源协议,代理
extension EmitionController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell, for: indexPath) as! EmoticonViewCell
        
        //设置数据
        //cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.blue : UIColor.yellow
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
    
    //代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        //将点击的表情插入最近分组中
        insertRecentlyEmoticon(emoticon: emoticon)
        
        //将表情回调给外界控制器
        emoticonCallBack(emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon : Emoticon) {
        //如果是空白或者删除 不需要
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        
        //删除一个表情
        if manager.packages.first!.emoticons.contains(emoticon) {
            //原来有这个表情
            let index = (manager.packages.first?.emoticons.firstIndex(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
        } else {
            //原来没有这个表情
            manager.packages.first?.emoticons.remove(at: 19)
        }
        //将emoticon插入最近分组
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}


class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //设置layout的属性
        let itemWH = UIScreen.main.bounds.width / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}
