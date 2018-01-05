//
//  BaseTabBarViewController.swift
//  FXDProduct
//
//  Created by admin on 2017/7/27.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
    
    let seleteimageArr = ["home_tab_select","mine_tab_select","more_tab_select"]
    let imageArr = ["home_tab_default","mine_tab_default","more_tab_default"]
    let titleArr = ["首页","我的","更多"]
    let vcNameArr = ["HomeViewController","MyViewController","MoreViewController"]
//    let vcNameArr = ["HomeRouter","MyRouter","MoreRouter"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabBarCon()
        // Do any additional setup after loading the view.
        
    }

    func setTabBarCon() -> Void {
        let resultArr = NSMutableArray()
        //swift使用 NSClassFromString 必须要获取app的名字
        let appname : String = APPTool.shareInstance.getAPPName()
        for i in 0...vcNameArr.count - 1 {
            if let vc  = NSClassFromString(appname + "." + vcNameArr[i]) as? UIViewController.Type{
                let viewcontroller  = vc.init()
                let navVC = BaseNavigationViewController.init(rootViewController: viewcontroller)
                    navVC.tabBarItem = self.tabBarNameAndImage(titleName: titleArr[i], defaultImageName: imageArr[i], selectImageName: seleteimageArr[i])
                    resultArr.add(navVC)
            }
            self.viewControllers =  resultArr as? [UIViewController]
        }
    }
    
     // TODO: 设置tabBar的item的名字 图片
    func tabBarNameAndImage(titleName : String,defaultImageName:String,selectImageName:String) -> UITabBarItem {
        
        let image = UIImage.init(named:defaultImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let chooseImage  = UIImage.init(named: selectImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let item = UITabBarItem.init(title: titleName, image: image, selectedImage: chooseImage)
//        item.setTitleTextAttributes({[NSForegroundColorAttributeName:UIColor.appTabBarTitleColor()]}(), for: UIControlState.normal)
        item.setTitleTextAttributes({[NSAttributedStringKey.foregroundColor:appMainBg]}(), for: UIControlState.selected)
        return item
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
