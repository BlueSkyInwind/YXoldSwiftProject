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
        self.view.backgroundColor  = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 19), NSAttributedStringKey.foregroundColor:UIColor.white]}()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "navigation"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK:  返回按钮
    func addBackItem() -> Void {
        let backButton = UIButton.init(type: UIButtonType.system)
        let img = UIImage.init(named: "return")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
