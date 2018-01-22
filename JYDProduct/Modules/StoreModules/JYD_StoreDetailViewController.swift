//
//  JYD_StoreDetailViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_StoreDetailViewController: BaseViewController {

    var storeID:String?
    
    var  storeDetailHeaderView:JYD_StoreDetailHeaderView?
    var storeDisplayPhotoView:JYD_StoreDisplayPhotoView?
    var startExternalMapBtn:UIButton?
    var handler:JYD_MapHandler?
    var storeImages:[String]?
    private lazy var modalDelegate: JYD_PhotoModalAnimationDelegate = JYD_PhotoModalAnimationDelegate()
    var storeDetailInfo:StoreDetailResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "门店详情"
        self.addWhiteBackItem()
        self.view.backgroundColor = VIEWCONTROLLERBG_Color
        // Do any additional setup after loading the view.
        handler = JYD_MapHandler.init()
        handler?.vc = self
        
        obtainStoreLocationInfo(storeID!) { (isSuccess) in
            if isSuccess {
                self.configureView()
            }
        }
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
        storeDetailHeaderView?.setContent(title: "\(storeDetailInfo?.storeName ?? "")", time: "借款时间：" + "\(storeDetailInfo?.businessHours ?? "")", address: "\(storeDetailInfo?.storeAddress ?? "")", amount:"\(storeDetailInfo?.loanAmount ?? "")", telStr: "电话:" + "\(storeDetailInfo?.storePhone ?? "")")
        storeDetailHeaderView?.callStoreTel = {
            self.makeStoreCallPhone("\(self.storeDetailInfo?.storePhone ?? "")")
        }
        self.view.addSubview(storeDetailHeaderView!)
        storeDetailHeaderView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(obtainBarHeight_New(vc: self) + 12)
            make.height.equalTo(140)
        })
        
        storeDisplayPhotoView = JYD_StoreDisplayPhotoView.init(frame: CGRect.zero, images: self.storeImages!)
        storeDisplayPhotoView?.clickIndex = { (index,photos) in
            let browseVC = JYD_StorePhotoBrowseViewController()
            browseVC.imageArr = photos;
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
        
        let latStr = (storeDetailInfo?.mapMarkLatitude)! as NSString
        let lonStr = (storeDetailInfo?.mapMarkLongitude)! as NSString
        let storeCoor = CLLocationCoordinate2DMake(latStr.doubleValue, lonStr.doubleValue)
        handler?.startExternalMaps(.MapAnnotation, fromLocation: APPUtilityInfo.shareInstance.userCurrentLocation!, fromName: "我的位置", toLocation: storeCoor, toName: (storeDetailInfo?.storeName!)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeStoreCallPhone(_ phoneNum:String)  {
        
        let alertSheetVC = UIAlertController.init(title: "门店电话", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let alertActionOne = UIAlertAction.init(title: phoneNum, style: UIAlertActionStyle.default, handler: { (action) in
            let phoneStr = "tel://" + phoneNum
            UIApplication.shared.openURL(URL.init(string: phoneStr)!)
        })
        alertSheetVC.addAction(alertActionOne)

        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
        }
        alertSheetVC.addAction(cancelAction)
        self.present(alertSheetVC, animated: true, completion: nil)
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

extension JYD_StoreDetailViewController {
    
    func obtainStoreLocationInfo(_ storeId:String,finish:@escaping ((_ isSuccess:Bool) -> Void))  {
        obtainStoreDetailInfo(storeId, successResponse: { (baseModel) in
            if baseModel.errCode == "0" {
                self.storeDetailInfo = StoreDetailResult.deserialize(from: (baseModel.data as! [String:Any]))
                self.storeImages = self.storeDetailInfo?.picList
                finish(true)
            }else{
                finish(false)
                MBPAlertView.shareInstance.showTextOnly(message: baseModel.friendErrMsg!, view: self.view)
            }
        }) { (error) in
            finish(false)
        }
    }
}



