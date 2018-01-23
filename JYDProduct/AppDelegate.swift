//
//  AppDelegate.swift
//  JYDProduct
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate {

    var window: UIWindow?
    var _mapManeger:BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        APPConfig.shareInstance.InitializeAppSet()
        initBMK()
    
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let homePage = JYD_HomePageViewController()
        let baseNav = BaseNavigationViewController.init(rootViewController: homePage)
        self.window?.rootViewController = baseNav
        self.window?.makeKeyAndVisible()

        return true
    }
    
    /// 百度地图初始化
    func initBMK()  {
        
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORDTYPE_BD09LL) {
            DPrint(message: "经纬度类型设置成功")
        } else {
            DPrint(message: "经纬度类型设置失败")
        }
        _mapManeger = BMKMapManager()
        //私有AK
        let ret = _mapManeger?.start(BMK_AK, generalDelegate: self)
        if ret == false {
            DPrint(message: "启动失败")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        APPConfig.shareInstance.systemLocationAuthStatus()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

