//
//  BaseViewController.swift
//  FXDProduct
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        addNavStyle()
    }
    
    func addNavStyle()  {
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 19), NSAttributedStringKey.foregroundColor:UIColor.white]}()
        //        self.navigationController?.navigationBar.backgroundColor = appMainBg
        self.navigationController?.navigationBar.setBackgroundImage(APPTool.shareInstance.imageWithColor(color: appMainBg), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func addWhiteNavStyle()  {
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 19), NSAttributedStringKey.foregroundColor:UIColor.black]}()
        self.navigationController?.navigationBar.setBackgroundImage(APPTool.shareInstance.imageWithColor(color: UIColor.white), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    
    // MARK:  返回按钮
    func addBackItem() -> Void {
        addNavBackItem(Image: UIImage.init(named: "appBackBtn_whiteIcon")!)
    }
    
    func addWhiteBackItem() -> Void {
        addNavBackItem(Image: UIImage.init(named: "appBackBtn_Icon")!)
    }
    
    func addNavBackItem(Image:UIImage)  {
        
        if #available(iOS 11.0, *){
            let  leftItem  = UIBarButtonItem.init(image: Image.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(popBack))
            self.navigationItem.leftBarButtonItem = leftItem
            return;
        }
        
        let backButton = UIButton.init(type: UIButtonType.system)
        let img = Image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        backButton.setImage(img, for: UIControlState.normal)
        backButton.frame = CGRect(x:0,y:0,width:45,height:44)
        backButton.addTarget(self, action:#selector(popBack), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem.init(customView: backButton)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spaceItem.width = -15
        self.navigationItem.leftBarButtonItems = [spaceItem,item]
    }
    
    @objc func popBack() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(NSStringFromClass(type(of: self)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(NSStringFromClass(type(of: self)))
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
