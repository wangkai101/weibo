//
//  PicPickerCollectionView.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/24.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {
    //MARK:-定义属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        
        //注册cell
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        
        dataSource = self
    }

}


extension PicPickerCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        
        //给cell设置数据
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
}
