//
//  HomeViewController.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/20.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

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
        
        //设置估算高度
        tableView.estimatedRowHeight = 200
        
        //布局header
        setupHeaderView()
       
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
    
    private func setupHeaderView() {
        //创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector(("loadNewStatuses")))
        
        //设置header的属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        //设置tableview的header
        tableView.mj_header = header
        
        //进入刷新状态
        tableView.mj_header.beginRefreshing()
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
    
    //加载最新数据
    @objc private func loadNewStatuses() {
        loadStatuses(isNewData: true)
    }
    
    //加载微博数据
    private func loadStatuses(isNewData : Bool) {
        
        //获取since_id
        var since_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }
        
        //请求数据
        NetworkTools.shareInstance.loadStatuses(since_id: since_id) { (result, error) in
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
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            //将数据g放入到成员变量的数组中
            self.viewModels = tempViewModel + self.viewModels
            
            //缓存图片
            self.cacheImages(viewModels: tempViewModel)
            
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
                    group.leave() //离开组
                }
            }
        }
        
        //刷新表格
            //当任务执行完后通知
        group.notify(queue: .main) {
            self.tableView.reloadData()
            
            //停止刷新
            self.tableView.mj_header.endRefreshing()
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
