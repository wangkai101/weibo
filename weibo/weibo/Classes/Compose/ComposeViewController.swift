//
//  ComposeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/23.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    //MARK:-懒加载属性
    private lazy var images : [UIImage] = [UIImage]()
    private lazy var emotionVc : EmitionController = EmitionController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
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
    //设置ui界面
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
        
        //监听点击删除图片的通知
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}


//MARK:- 事件监听
extension ComposeViewController {
    
    @IBAction func closeItemClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendItemClick(_ sender: Any) {
        //退出键盘
        textView.resignFirstResponder()
        
        //获取发送微博的微博正文
        let statusText = textView.getEmoticonString()
        
        //调用接口发送微博
        NetworkTools.shareInstance.sendStatus(statusText: statusText) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            
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
    
    @IBAction func emoticonBtnClick() {
        //退出键盘
        textView.resignFirstResponder()
        
        //切换键盘
        textView.inputView = textView.inputView != nil ? nil : emotionVc.view
        
        //弹出键盘
        textView.becomeFirstResponder()
    }
    
    //监听键盘改变，实现toolbar的bottom约束移动
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
    
    @objc private func removePhotoClick(note : Notification) {
        //获取image对象
        guard let image = note.object as? UIImage else {
            return
        }
        
        //获取image对象所在下标值
        guard let index = images.firstIndex(of: image) else {
            return
        }
        
        //将图片从数组中删除
        images.remove(at: index)
        
        //重写赋值collectionview新的数组
        picPickerView.images = images
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

