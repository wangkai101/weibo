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
    @IBOutlet weak var remvePhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                remvePhotoBtn.isHidden = false
            } else {
                imageView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                remvePhotoBtn.isHidden = true
            }
        }
    }
    
    
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    
    @IBAction func removePhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: imageView.image)
    }
}
