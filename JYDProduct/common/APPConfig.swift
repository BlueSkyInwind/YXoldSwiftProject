//
//  APPConfig.swift
//  FXDProduct
//
//  Created by admin on 2017/8/1.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManager

class APPConfig: NSObject {
    
    static let shareInstance = APPConfig()
    
    func InitializeAppSet() -> Void {
        
        netWorkStatus()
        ThirdSourceInit()
        userInfoInit()
        
    }
    
    // MARK: 网络监测
    func netWorkStatus() -> Void {
        let net = NetworkReachabilityManager()
        net?.listener = { status in
            switch status {
            case .notReachable , .unknown:
                APPUtilityInfo.shareInstance.networkState = false
                break
            case .reachable(.ethernetOrWiFi) , .reachable(.wwan):
                APPUtilityInfo.shareInstance.networkState = true
                break
            }
        }
        net?.startListening()
    }
    
    //MARK: 三方库的初始化
    func ThirdSourceInit() -> Void
    {
        UMAnalyticsConfig.sharedInstance().appKey = Umeng_Key
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        MobClick.setAppVersion(APPTool.shareInstance.getAPPVersion())
        MobClick.setLogEnabled(true)
        
        IQKeyboardManager.shared().toolbarManageBehaviour = IQAutoToolbarManageBehaviour.byPosition
        IQKeyboardManager.shared().shouldResignOnTouchOutside  = true
        IQKeyboardManager.shared().shouldToolbarUsesTextFieldTintColor  = true
    }
    
    // MARK: 用户数据初始化
    func userInfoInit() ->  Void{
        
        
    }

}
