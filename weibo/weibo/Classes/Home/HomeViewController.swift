//
//  HomeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/20.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController {

    
//MARK:- 懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
    private lazy var popoverAnimator : Popoveranimator = Popoveranimator {[weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    private lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //没有登录时设置的内容
        visitorView.addRotationAnimal()
        if !isLogin {
            return
        }
       
        //设置导航栏的内容
        setupNavigationBar()
        
        //请求数据
        loadStatuses()
        
        //设置估算高度
        tableView.estimatedRowHeight = 200
       
    }
}

//MARK:- 设置UI界面
extension HomeViewController {
    private func setupNavigationBar() {
        //设置左侧Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        //设置右侧Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //设置btitleView
        titleBtn.setTitle("wanger", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn

    }
}


//MARK:- 事件监听的函数
extension HomeViewController {
    @objc private func titleBtnClick() {
        titleBtn.isSelected = !titleBtn.isSelected
        
        //创建弹出的控制器
        let popoverVc = PopViewController()
        
        //设置modal的弹出样式(如果不设置会使弹出前的画面默认移除)
        popoverVc.modalPresentationStyle = .custom
        
        //设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 100, width: 180, height: 250)
        
        //弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}

//MARK:-请求数据
extension HomeViewController {
    private func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            //错误校验
            if error != nil {
                print(error)
                return
            }
            
            //获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            //遍历微博对应的字典
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
                }
            
            //缓存图片
            self.cacheImages(viewModels: self.viewModels)
            
        }
    }
    
    private func cacheImages(viewModels : [StatusViewModel]) {
        //创建group
        let group = DispatchGroup()
        
        //缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter() //进入组
                
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil) { (_, _, _, _, _, _) in
                    print("下载了一张照片")
                    
                    group.leave() //离开组
                }
            }
        }
        
        //刷新表格
            //当任务执行完后通知
        group.notify(queue: .main) {
            self.tableView.reloadData()
            print("刷新表格")
        }
    }
}

//MARK:- tableView的数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        
        //给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //获取模型对象
        let viewModel = viewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
}
