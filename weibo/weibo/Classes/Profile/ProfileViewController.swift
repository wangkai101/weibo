//
//  ProfileViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/24.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.setupvisitorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }

}
