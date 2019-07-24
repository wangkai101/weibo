//
//  ComposeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/23.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    private lazy var images : [UIImage] = [UIImage]()
    
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var sendItemBtn: UIBarButtonItem!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    

    //约束的属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeightCons: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置ui
        setupUI()
        //监听通知
        setupNotification()
    
        
    }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            textView.becomeFirstResponder()
        }
    
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:- 设置ui界面
extension ComposeViewController {
    private func setupUI() {
        
        //更新title用户昵称
        screenNameLabel.text = UserAccountTool.shareIntance.account?.screen_name
    }
    
    //监听通知
    private func setupNotification() {
        //监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //监听点击添加图片的通知
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
}


//MARK:- 事件监听
extension ComposeViewController {
    
    @IBAction func closeItemClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendItemClick(_ sender: Any) {
        print("发送")
    }
    
    @objc private func keyboardWillChangeFrame(note : Notification) {
        //获取动画执行的时间
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        //获取键盘最终y值
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        //计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y

        //执行动画
        toolBarBottomCons.constant = -margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPicker() {
        //退出键盘
        textView.resignFirstResponder()
        
        

        //执行动画
        picPickerViewHeightCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        //addPhotoClick()
    }
}

//MARK:- 添加照片和删除照片的事件
extension ComposeViewController {
    @objc private func addPhotoClick() {
        //判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        //创建照片选择控制器
        let ipc = UIImagePickerController()
        
        //设置照片源
        ipc.sourceType = .photoLibrary
        
        //设置代理
        ipc.delegate = self
        
        //弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
        
    }
}

//MARK:-UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获取选中的照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //展示照片
        images.append(image)
        
        //将数组赋值给collectionView，让其展示数据
        picPickerView.images = images
        
        //判断发送按钮是否能够点击
        if images.count != 0 {
            sendItemBtn.isEnabled = true
        }
        //退出选中照片控制器
        dismiss(animated: true, completion: nil)
        
    }
}


//MARK:- UITextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    //当文本框发生改变
    func textViewDidChange(_ textView: UITextView) {
       self.textView.placeholderLaber.isHidden = textView.hasText
        sendItemBtn.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    
}

