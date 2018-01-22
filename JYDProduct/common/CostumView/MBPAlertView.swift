//
//  MBPAlertView.swift
//  FXDProduct
//
//  Created by admin on 2017/8/1.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit
import MBProgressHUD

class MBPAlertView: NSObject {
    
    static let shareInstance = MBPAlertView()
    
    var waitHUb:MBProgressHUD?
    
    //MARK: 提示信息框
    func showTextOnly(message:String,view:UIView) -> Void {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = message
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 12)
        hud.bezelView.color = UIColor.black
        hud.detailsLabel.textColor = UIColor.white
        hud.margin = 13
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1)
    }
    
    //MARK: 进度条
    func showWaitView(view:UIView)  {
        if waitHUb != nil {
            return
        }
        waitHUb = MBProgressHUD.init(view: view)
        waitHUb?.mode = MBProgressHUDMode.indeterminate
        waitHUb?.animationType = MBProgressHUDAnimation.zoomIn;
        waitHUb?.removeFromSuperViewOnHide = true
//        waitHUb?.label.text = "Loading...";
        waitHUb?.label.textColor = UIColor.white;
        waitHUb?.bezelView.color = UIColor.black
        if #available(iOS 9.0, *) {
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.white
        } else {
            waitHUb?.activityIndicatorColor = UIColor.white
        }
        view.addSubview(waitHUb!)
        waitHUb?.show(animated: true)
    }
    
    func removeWaitView()  {
        waitHUb?.hide(animated: true, afterDelay: 0)
        waitHUb = nil
    }
}
