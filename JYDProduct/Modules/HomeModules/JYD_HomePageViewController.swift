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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = Home_NavTitle
        
        configureView()
        PopImageView()
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
            let storeListVC = JYD_StoreListViewController()
            self.navigationController?.pushViewController(storeListVC, animated: true)
        }
        self.view.addSubview(headerView!)
        headerView?.snp.makeConstraints({ (make) in
            make.top.equalTo(obtainBarHeight_New(vc: self) + 20)
            make.left.equalTo(self.view.snp.left).offset(APPTool.obtainDisplaySize(size: 15))
            make.right.equalTo(self.view.snp.right).offset(-(APPTool.obtainDisplaySize(size: 15)))
            make.height.equalTo(APPTool.obtainDisplaySize(size: 50))
        })
    }
    
    func PopImageView() {
        homePopView  = JYD_HomePopView.init(frame: CGRect.zero, image: UIImage.init(named: "TEST")!)
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
        _mapView?.mapScaleBarPosition = CGPoint(x: 10, y: (_mapView?.frame.height)! - 45)
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
    
    func addPointAnnotation()  {
        let locationCoordinate1 = CLLocationCoordinate2DMake(39.915, 116.404)
        let locationCoordinate2 = CLLocationCoordinate2DMake(39.950, 116.430)
        let locationCoordinate3 = CLLocationCoordinate2DMake(39.869, 116.410)
        let locationCoordinate4 = CLLocationCoordinate2DMake(39.930, 116.390)
        let locationCoordinate5 = CLLocationCoordinate2DMake(39.890, 116.450)
        let arr =  [locationCoordinate1,locationCoordinate2,locationCoordinate3,locationCoordinate4,locationCoordinate5]
        for location in arr {
            let annotationPoint = BMKPointAnnotation.init()
            annotationPoint.coordinate = location
            annotationPoint.title = "这一家店" 
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
            annotationView?.paopaoView = addCustomPaopaoView(content: "这是一家福利店")
            annotationView?.animatesDrop = true
            annotationView?.image = UIImage.init(named: "storeLocation_Icon")
            annotationView?.isDraggable = false
            annotationView?.annotation = annotation
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        
        mapView.setCenter(view.annotation.coordinate, animated: true)
        showPopupBottomView()
        DPrint(message: "点击大头针,移动至中心点  ---- \(view.annotation.coordinate)")
    }
    
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
        DPrint(message: "取消泡泡")
        cancelBottomView()
    }
    
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        DPrint(message: "点击了泡泡")
        let selectStoreVC = JYD_SelectPathViewController.init()
        self.navigationController?.pushViewController(selectStoreVC, animated: true)
    }
    
    //MARK:JYD_MapHandlerDelegate 地图控件
    func addRepositionButtonClick() {
        DPrint(message: "重新定位")
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
    func showPopupBottomView() {
        if bottomView != nil {
            return
        }
        bottomView = JYD_homeBottomView.init(vc: self, titleStr: "星巴克门店（营业中）", timeStr: "借款时间：9:00-18:00", addressStr: "浦东新区金高路35", distanceStr: "680m")
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
        addCircleView(userLocation.location.coordinate)
        addPointAnnotation()
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
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
