//
//  ComposeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/23.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

    class ComposeViewController: UIViewController, UITextViewDelegate {
    
        @IBOutlet weak var textView: UITextView!
        @IBOutlet weak var placeHolderLabel: UILabel!
        @IBOutlet weak var sendItemBtn: UIBarButtonItem!
        @IBOutlet weak var screenNameLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        sendItemBtn.isEnabled = false
        
        screenNameLabel.text = UserAccountTool.shareIntance.account?.screen_name
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 0, right: 7)
        
        
    }
}

//MARK:- 设置ui界面
extension ComposeViewController {
    
}


//MARK:- 事件监听
extension ComposeViewController {
    
    @IBAction func closeItemClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendItemClick(_ sender: Any) {
        print("发送")
    }
}

//实现textView的协议
extension ComposeViewController {
    //当点击文本框时，使占位label隐藏
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
}
