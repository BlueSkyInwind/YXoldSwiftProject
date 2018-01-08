//
//  JYD_StoreDetailViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_StoreDetailViewController: BaseViewController {

    var  storeDetailHeaderView:JYD_StoreDetailHeaderView?
    var storeDisplayPhotoView:JYD_StoreDisplayPhotoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "门店详情"
        self.addBackItem()
        // Do any additional setup after loading the view.
        
        configureView()
    }
    
    func configureView()  {
        
        storeDetailHeaderView = JYD_StoreDetailHeaderView.loadNib("JYD_StoreDetailHeaderView")
        storeDetailHeaderView?.setContent(title: "星巴克门店（营业中）", time: "借款时间：9:00-18:00", address: "借款额度：1000-5000元", amount: "借款额度：1000-5000元", telStr: "电话:020-4349596")
        self.view.addSubview(storeDetailHeaderView!)
        storeDetailHeaderView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(obtainBarHeight_New(vc: self) + 12)
            make.height.equalTo(140)
        })
        
        storeDisplayPhotoView = JYD_StoreDisplayPhotoView.init(frame: CGRect.zero, images: [])
        self.view.addSubview(storeDisplayPhotoView!)
        storeDisplayPhotoView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(10)
            make.height.equalTo(APPTool.obtainDisplaySize(size: 150))
        })
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
