//
//  JYD_HomePageViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_HomePageViewController: BaseViewController,BMKMapViewDelegate,JYD_MapHandlerDelegate, BMKLocationServiceDelegate {

    
    var _mapView:BMKMapView?
    var locationService: BMKLocationService!

    var circleView:BMKCircle?
    var handler:JYD_MapHandler?
    var headerView:JYD_HomeHeaderView?
    var bottomView:JYD_homeBottomView?
    
    var zoomSize:Float = 14
    var homePopView:JYD_HomePopView?
    
    var currentLocation:CLLocationCoordinate2D?
    var storeLocations:[BMKAnnotation]? = []
    var storeInfos:[StoreListResult]? = []
    
    var isObtainAnn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = Home_NavTitle
        
        configureView()
        obtainPopViewInfo {[weak self]  (isSuccess,model) in
            self?.PopImageView(model.image!)
        }
        
    }
    
    func configureView()  {
        
        locationService = BMKLocationService()

        _mapView = BMKMapView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height))
        self.view.addSubview(_mapView!)
        _mapView?.zoomLevel = zoomSize
        addMapScaleBar()
        
        handler = JYD_MapHandler.init()
        handler?.delegate = self
        handler?.vc = self
        handler?.addRepositionBtn(CGPoint.init(x: 10, y: _k_h / 2))
        handler?.addZoomView(CGPoint.init(x: _k_w - 60, y: _k_h / 2))
        
        //MARK:头部视图
        headerView = JYD_HomeHeaderView.init(frame: CGRect.zero)
        headerView?.rightIconButtonClick = {
            self.pushStoreListVC()
        }
        self.view.addSubview(headerView!)
        headerView?.snp.makeConstraints({ (make) in
            make.top.equalTo(obtainBarHeight_New(vc: self) + 20)
            make.left.equalTo(self.view.snp.left).offset(APPTool.obtainDisplaySize(size: 15))
            make.right.equalTo(self.view.snp.right).offset(-(APPTool.obtainDisplaySize(size: 15)))
            make.height.equalTo(APPTool.obtainDisplaySize(size: 50))
        })
    }
    
    func PopImageView(_ urlStr:String) {
        homePopView  = JYD_HomePopView.init(frame: CGRect.zero, imageStr: urlStr)
        homePopView?.popImageTap = {
            
        }
        UIApplication.shared.keyWindow?.addSubview(homePopView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
        locationService.delegate = self
        setUserLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
    }
    
    func addMapScaleBar()  {
        
        _mapView?.showMapScaleBar = true
        _mapView?.mapScaleBarPosition = CGPoint(x: 10, y:  _k_h / 2 + 100)
        _mapView?.mapPadding = UIEdgeInsetsMake(0, 0, 28, 0)
    }
    
    //MARK:自定义精度圈
    func customLocationAccuracyCircle() {
        let param = BMKLocationViewDisplayParam()
        param.accuracyCircleStrokeColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        param.accuracyCircleFillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.3)
        param.locationViewImgName = ""
        _mapView?.updateLocationView(with: param)
    }  
    //MRAK:用户定位
    func setUserLocation()  {
        locationService.startUserLocationService()
        isObtainAnn = true
        locationService.allowsBackgroundLocationUpdates = false
        _mapView?.showsUserLocation = false//先关闭显示的定位图层
        _mapView?.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView?.showsUserLocation = true//显示定位图层
    }
    
    //MRAK:添加图层与点
    func addCircleView(_ Location:CLLocationCoordinate2D)  {
        if circleView != nil {
            _mapView?.removeOverlays(_mapView?.overlays)
        }
        circleView = BMKCircle(center: Location, radius: 5000)
        _mapView?.add(circleView!)
    }
    
    func addPointAnnotation(_ locInfos:[StoreListResult])  {
        //清空门店信息
        self.storeInfos?.removeAll()
        self.storeInfos = locInfos
        //清空位置信息
        _mapView?.removeAnnotations(storeLocations)
        storeLocations?.removeAll()
        for Info in locInfos {
            let lat = Double(Info.mapMarkLatitude!)
            let lon = Double(Info.mapMarkLongitude!)
            let storeCoor = CLLocationCoordinate2DMake(lat!, lon!)
            let annotationPoint = JYD_PointAnnotation.init()
            annotationPoint.coordinate = storeCoor
            annotationPoint.title = "这一家店"
            annotationPoint.storeInfoModel = Info
            _mapView?.addAnnotation(annotationPoint)
        }
    }
    
    /// 增加自定义的view
    ///
    /// - Parameter content: 内容
    /// - Returns: 返回视图
    func addCustomPaopaoView(content:String) -> BMKActionPaopaoView {
        let paoPaoView = JYD_PaopaoView.init(frame: CGRect.zero)
        paoPaoView.contentLabel?.text = content
        let bmkPaopaoView  = BMKActionPaopaoView.init(customView: paoPaoView)
        return bmkPaopaoView!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if (overlay as? BMKCircle) != nil {
            let circleView = BMKCircleView(overlay: overlay)
            circleView?.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            circleView?.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            //            circleView?.lineWidth = 5
            return circleView
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if  annotation.isKind(of: BMKPointAnnotation.self ){
            let AnnotationViewID = "pointReuseIndentifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as! BMKPinAnnotationView?
            if annotationView == nil {
                annotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: AnnotationViewID)
            }
            annotationView?.animatesDrop = true
            annotationView?.image = UIImage.init(named: "storeLocation_Icon")
            annotationView?.isDraggable = false
            annotationView?.annotation = annotation
            storeLocations?.append(annotation)
            if (annotationView?.annotation.isKind(of: JYD_PointAnnotation.self))!{
                let annV = annotationView?.annotation as! JYD_PointAnnotation
                annotationView?.paopaoView = addCustomPaopaoView(content: (annV.storeInfoModel?.storeName)!)
                DPrint(message: annV.storeInfoModel)
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        
        if view.annotation.isKind(of: JYD_PointAnnotation.self) {
            let annV = view?.annotation as! JYD_PointAnnotation
            mapView.setCenter(view.annotation.coordinate, animated: true)
            showPopupBottomView(storeInfo: annV.storeInfoModel!)
            DPrint(message: "点击大头针,移动至中心点  ---- \(view.annotation.coordinate)")
        }
    }
    
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
        DPrint(message: "取消泡泡")
        cancelBottomView()
    }
    
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        DPrint(message: "点击了泡泡")
        if view.annotation.isKind(of: JYD_PointAnnotation.self) {
            let annV = view?.annotation as! JYD_PointAnnotation
            pushPathListVC((annV.storeInfoModel)!)
        }
    }
    
    //MARK:JYD_MapHandlerDelegate 地图控件
    func addRepositionButtonClick() {
        DPrint(message: "重新定位")
        zoomSize = 14
        _mapView?.zoomLevel = zoomSize
        isObtainAnn = true
        locationService.startUserLocationService()
    }
  
    func addMapEnlargedButtonClick() {
        zoomSize += 1
        _mapView?.zoomLevel = zoomSize
    }
    
    func addMapShrinkButtonClick() {
        zoomSize -= 1
        _mapView?.zoomLevel = zoomSize
    }

    //MARK:底部选择弹窗
    func showPopupBottomView(storeInfo:StoreListResult) {
        if bottomView != nil {
            return
        }
        bottomView = JYD_homeBottomView.init(vc: self, titleStr: storeInfo.storeName! , timeStr: "借款时间：" + storeInfo.businessHours!, addressStr: storeInfo.storeAddress!, distanceStr: storeInfo.distance!)
        bottomView?.displayPathTapClick = {[weak self] in
            self?.pushPathListVC(storeInfo)
        }
        bottomView?.storeDetailTapClick = { [weak self] in
            self?.pushStoreDetailVC(storeInfo)
        }
        bottomView?.VC = self
        bottomView?.show()
    }
    
    func cancelBottomView()  {
        bottomView?.dismiss()
        bottomView = nil
    }
    
    // MARK: - BMKLocationServiceDelegate
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
        print("willStartLocatingUser");
    }
    
    /**
     *用户方向更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        print("heading is \(userLocation.heading)")
        _mapView?.updateLocationData(userLocation)
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdate(_ userLocation: BMKUserLocation!) {
        DPrint(message: "didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        _mapView?.setCenter(userLocation.location.coordinate, animated: true)
        _mapView?.updateLocationData(userLocation)
//        addCircleView(userLocation.location.coordinate)
        currentLocation = userLocation.location.coordinate
        APPUtilityInfo.shareInstance.userCurrentLocation = currentLocation
        if isObtainAnn {
            isObtainAnn = false
            obtainStoreLocationInfo(currentLocation!)
        }
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
    }
    
    //MARK:页面跳转
    func  pushStoreListVC()  {
        guard (self.storeInfos?.count != 0) else {
            MBPAlertView.shareInstance.showTextOnly(message: "重新定位获取门店", view: self.view)
            return
        }
        let storeListVC = JYD_StoreListViewController()
        storeListVC.storeInfolists = self.storeInfos
        self.navigationController?.pushViewController(storeListVC, animated: true)
    }
    
    func pushPathListVC(_ storeInfo:StoreListResult)  {
        
        guard (storeInfo != nil) else {
            return
        }
        
        let latStr = storeInfo.mapMarkLatitude! as NSString
        let lonStr = storeInfo.mapMarkLongitude! as NSString
        let storeCoor = CLLocationCoordinate2DMake(latStr.doubleValue, lonStr.doubleValue)
        let selectStoreVC = JYD_SelectPathViewController.init()
        selectStoreVC.startCoord = currentLocation
        selectStoreVC.endCoord = storeCoor
        selectStoreVC.endLoactionName = storeInfo.storeName!
        self.navigationController?.pushViewController(selectStoreVC, animated: true)
    }
    
    func pushStoreDetailVC(_ storeInfo:StoreListResult){
        let storeDetailVC = JYD_StoreDetailViewController()
        storeDetailVC.storeID = storeInfo.storeId
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
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

//MARK:数据请求处理
extension JYD_HomePageViewController {
    
    func obtainStoreLocationInfo(_ currentlocation:CLLocationCoordinate2D)  {
        obtainStoreListLocationInfo(currentlocation, successResponse: { (baseModel) in
            if baseModel.errCode == "0" {
                let storeLists = baseModel.data
                var storeLocationInfoArr:[StoreListResult] = []
                for dic in storeLists! {
                    let storeLocationInfo = StoreListResult.deserialize(from: (dic as! [String:Any]))
                    storeLocationInfoArr.append(storeLocationInfo!)
                }
                self.addPointAnnotation(storeLocationInfoArr)
            }else{
                MBPAlertView.shareInstance.showTextOnly(message: baseModel.friendErrMsg!, view: self.view)
            }
        }) { (error) in
            
        }
    }
    
    func obtainPopViewInfo(_ finish:@escaping ((_ isSuccess:Bool,_ model:HomePopResult) -> Void))  {
        obtainHomePopViewInfo({ (baseModel) in
            if baseModel.errCode == "0" {
                let array = baseModel.data
                do {
                    let popModel = HomePopResult.deserialize(from: (array?.first as! [String:Any]))
                    finish(true,popModel!)
                }catch{
                    
                }
            }else{
                MBPAlertView.shareInstance.showTextOnly(message: baseModel.friendErrMsg!, view: self.view)
            }
        }) { (error) in
        }
    }
}


