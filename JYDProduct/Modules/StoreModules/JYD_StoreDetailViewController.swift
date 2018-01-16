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
    var startExternalMapBtn:UIButton?
    var handler:JYD_MapHandler?
    var storeImages:[UIImage]?
    private lazy var modalDelegate: JYD_PhotoModalAnimationDelegate = JYD_PhotoModalAnimationDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "门店详情"
        self.addWhiteBackItem()
        // Do any additional setup after loading the view.
        handler = JYD_MapHandler.init()
        handler?.vc = self
        storeImages = [UIImage.init(named: "TEST")!,UIImage.init(named: "TEST")!,UIImage.init(named: "TEST")!,UIImage.init(named: "TEST")!]
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addWhiteNavStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addNavStyle()
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
        
        storeDisplayPhotoView = JYD_StoreDisplayPhotoView.init(frame: CGRect.zero, images: self.storeImages!)
        storeDisplayPhotoView?.clickIndex = { (index) in
            let browseVC = JYD_StorePhotoBrowseViewController()
            browseVC.imageArr = self.storeImages;
            browseVC.selectIndex = index
            browseVC.transitioningDelegate = self.modalDelegate
            browseVC.modalPresentationStyle = .custom
            self.present(browseVC, animated: true, completion: nil)
        }
        self.view.addSubview(storeDisplayPhotoView!)
        storeDisplayPhotoView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo((storeDetailHeaderView?.snp.bottom)!).offset(10)
            make.height.equalTo(APPTool.obtainDisplaySize(size: 150))
        })
        
        startExternalMapBtn = UIButton.init(type: UIButtonType.custom)
        startExternalMapBtn?.setTitle(StartMapButtonTitle, for: UIControlState.normal)
        startExternalMapBtn?.setTitleColor(UIColor.white, for: UIControlState.normal)
        startExternalMapBtn?.backgroundColor = appMainBg
        startExternalMapBtn?.layer.cornerRadius = 5
        startExternalMapBtn?.clipsToBounds = true
        startExternalMapBtn?.addTarget(self, action: #selector(startExternalMapBtnClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(startExternalMapBtn!)
        startExternalMapBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view.snp.left).offset(APPTool.obtainDisplaySize(size: 50))
            make.right.equalTo(self.view.snp.right).offset(-APPTool.obtainDisplaySize(size: 50))
            make.height.equalTo(APPTool.obtainDisplaySize(size: 42))
            make.bottom.equalTo(self.view.snp.bottom).offset(-(APPTool.obtainDisplaySize(size: 100)))
        })
    }
    
    @objc func startExternalMapBtnClick() {
        handler?.startExternalMaps(.MapTransit, fromLocation: CLLocationCoordinate2DMake(31.315, 121.5247), fromName: "", toLocation: CLLocationCoordinate2DMake(31.315, 121.5287), toName: "")
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
