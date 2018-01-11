//
//  JYD_StorePhotoBrowseViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_StorePhotoBrowseViewController: UIViewController {

    var  storePhotoBrowseView:JYD_StorePhotoBrowseView?
    
    var imageArr:[UIImage]?
    var selectIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView()  {
        storePhotoBrowseView = JYD_StorePhotoBrowseView.init(frame: CGRect.init(x: 0, y: 0, width: _k_w, height: _k_h), displayImages: imageArr!, selectIndex: selectIndex!)
        self.view.addSubview(storePhotoBrowseView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
