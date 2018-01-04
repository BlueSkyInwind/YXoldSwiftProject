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
    
    //MARK: 提示信息框
    func showTextOnly(message:String,view:UIView) -> Void {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = message
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 12)
        hud.margin = 13
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1)
    }
}
