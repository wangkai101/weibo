//
//  ComposeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/23.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    

    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var sendItemBtn: UIBarButtonItem!
        @IBOutlet weak var screenNameLabel: UILabel!
    
    //约束的属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置ui
        setupUI()
        
        //监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillShowNotification, object: nil)
        
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
        sendItemBtn.isEnabled = false
        
        //更新title用户昵称
        screenNameLabel.text = UserAccountTool.shareIntance.account?.screen_name

        
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

