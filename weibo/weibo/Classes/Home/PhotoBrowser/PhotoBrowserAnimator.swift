//
//  PhotoBrowserAnimator.swift
//  weibo
//
//  Created by Mr wngkai on 2019/7/28.
//  Copyright © 2019 Mr wngkai. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
    
}


extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissView(using: transitionContext)
    }
    
    //自定义弹出动画
    func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        //取出弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //将presentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        //执行动画
        presentedView.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    //自定义消失动画
    func animationForDismissView(using transitionContext: UIViewControllerContextTransitioning) {
        //取出消失的view
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        //执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.alpha = 0
        }) { (_) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    
}
