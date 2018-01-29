//
//  JYD_PhotoModalAnimationDelegate.swift
//  JYDProduct
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_PhotoModalAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate {

    private var isPresentAnimationing: Bool = true

}

extension JYD_PhotoModalAnimationDelegate:UIViewControllerAnimatedTransitioning  {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimationing = true
        return self
    }
 
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimationing = false
        return self
    }
}


extension JYD_PhotoModalAnimationDelegate {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresentAnimationing ? presentViewAnimation(transitionContext: transitionContext) : dismissViewAnimation(transitionContext: transitionContext)
    }
    
    func presentViewAnimation(transitionContext: UIViewControllerContextTransitioning)  {
        
        //创建过度view
        let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        //容器view
        let  containerView = transitionContext.containerView
//        containerView.backgroundColor = UIColor.black
        guard let _ = destinationView else {
            return
        }
        //过度的view添加到容器的view上
        containerView.addSubview(destinationView!)
        //目标控制器
        let destinationController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? JYD_StorePhotoBrowseViewController
        let index = (destinationController?.selectIndex)! - 1
        let destinationImageView = destinationController?.storePhotoBrowseView?.imageViewArr[index]
        //当前跳转的控制器
        let currentController = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)  as! UINavigationController).topViewController as! JYD_StoreDetailViewController
        //图片的view
        let photoView = currentController.storeDisplayPhotoView
        let imageView = photoView?.imageViewArr[index]
        // 新建一个imageview添加到目标view之上,做为动画view
        let annimateView = UIImageView()
        annimateView.image = photoView?.photos![index]
        annimateView.contentMode = .scaleAspectFill
        annimateView.clipsToBounds = true
        // 被选中的Image到目标view上的座标转换
        let originFrame = imageView?.convert((imageView?.photoBtn?.frame)!, to: UIApplication.shared.keyWindow)
        annimateView.frame = originFrame!
        containerView.addSubview(annimateView)
        var vframe = destinationImageView?.frame
        let width = (vframe?.size.width)! - 10
        vframe?.size.width = width
        let endFrame = vframe
        destinationView?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            annimateView.frame = endFrame!
            annimateView.center = CGPoint.init(x: _k_w / 2, y: _k_h / 2)
            destinationView?.alpha = 1
        }) { (finished) in
            transitionContext.completeTransition(true)
            annimateView.removeFromSuperview()
        }
    }
    
    func dismissViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        let transitionView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let contentView = transitionContext.containerView
        // 取出modal出的来控制器
        let destinationController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! JYD_StorePhotoBrowseViewController
        // 取出当前显示的collectionview
        let presentView = destinationController.storePhotoBrowseView
        let displayImageView = presentView?.imageViewArr[(presentView?.selectDisplayImage)!]
        //新建过渡动画imageview
        let annimateView = UIImageView()
        annimateView.image = displayImageView?.image
        annimateView.contentMode = .scaleAspectFill
        annimateView.clipsToBounds = true
        annimateView.frame = (displayImageView?.frame)!
        annimateView.center = CGPoint.init(x: _k_w/2, y: _k_h/2)
        contentView.addSubview(annimateView)
        // 取出要返回的控制器view
        let currentController = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)  as! UINavigationController).topViewController as! JYD_StoreDetailViewController
        let originView = currentController.storeDisplayPhotoView?.imageViewArr[(presentView?.selectDisplayImage)!]
        let originFrame = originView?.convert((originView?.photoBtn?.frame)!, to: UIApplication.shared.keyWindow)
        UIView.animate(withDuration: 0.5, animations: {
            annimateView.frame = originFrame!
            transitionView?.alpha = 0
        }) { (_) in
            annimateView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

