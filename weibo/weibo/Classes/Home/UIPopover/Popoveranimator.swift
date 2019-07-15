//
//  Popoveranimator.swift
//  weibo
//
//  Created by Mr wngkai on 2019/6/28.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class Popoveranimator: NSObject {
    //MARK:- 对外提供的属性
    var presentedFrame : CGRect = CGRect.zero
    var isPresented : Bool = false

    var callBack : ((Bool) -> ())?
    
    //MARK:- 自定义构造函数
    init(callBack : @escaping (Bool) -> ()) {
        self.callBack = callBack
    }
    
}

//MARK:- 自定义转场代理的方法
extension Popoveranimator : UIViewControllerTransitioningDelegate {
    //目的:改变弹出view的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = PoppresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    //目的:自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    //目的：自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        callBack!(isPresented)
        return self
    }
}


//MARK:- 弹出和消失动画代理的方法
extension Popoveranimator : UIViewControllerAnimatedTransitioning {
    //动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    //获取转场的上下文：可以通过转场上下文获取弹出的view和消失的view
    //UItransitionContextFromViewKey : 获取消失的view
    //UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissedView(using: transitionContext)
    }
    
    //自定义弹出动画
    private func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        //获取弹出的view
        let presentedView = transitionContext.view(forKey: .to)!
        
        //将弹出的view添加到containerView
        transitionContext.containerView.addSubview(presentedView)
        
        //执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
        }) { (_) in
            //必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    //自定义消失动画
    private func animationForDismissedView(using transitionContext: UIViewControllerContextTransitioning) {
        //获取弹出的view
        let dismissedView = transitionContext.view(forKey: .from)!
        
        //执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.001)
        }) { (_) in
            //必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
