//
//  PicPickerViewCell.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/24.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    var image : UIImage? {
        didSet {
            if image != nil {
                addPhotoBtn.setBackgroundImage(image, for: .normal)
                addPhotoBtn.isUserInteractionEnabled = false
                
            } else {
                addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
                addPhotoBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    
}
