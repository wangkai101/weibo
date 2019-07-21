//
//  PicCollectionView.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/21.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {
    
    //MARK:- 定义属性
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
    }
}

//MARK:- collectionView的数据源方法
extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        //给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
}




class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    //MARK:- 定义模型属性
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
}
