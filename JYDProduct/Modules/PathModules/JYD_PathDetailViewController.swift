//
//  JYD_PathDetailViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_PathDetailViewController: BaseViewController ,BMKMapViewDelegate,JYD_SelectPathDetailRouterViewDelegate,JYD_MapHandlerDelegate, BMKLocationServiceDelegate{
    
    var _mapView:BMKMapView?
    //地图缩放尺寸
    var zoomSize:Float = 14
    //mapHandler
    var handler:JYD_MapHandler?
    var busRoute: BMKMassTransitRouteLine?
    var drivingRoute: BMKDrivingRouteLine?
    var walkingRoute: BMKWalkingRouteLine?
    var ridingRoute: BMKRidingRouteLine?
    //路线数据数组
    var dataArray : NSMutableArray = []
    //交通工具tag值
    var tag : Int?
 
    //定位
    var locationService: BMKLocationService!
    //驾车描述
    var drivingDesc:String?
    var pathHandler:JYD_PathHandler?
    var bottomView : JYD_SelectPathDetailRouterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Home_NavTitle
        addBackItem()
        mapView()
        bottomView = JYD_SelectPathDetailRouterView()
        bottomView?.delegate = self

        self.view.addSubview(bottomView!)
        bottomView?.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.height.equalTo(238)
        }
        pathHandler = JYD_PathHandler.init()
        getRouteDetailInfo()
        bottomView?.dataArray = dataArray
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillAppear()
        
        locationService.delegate = self
        _mapView?.delegate = self
        setUserLocation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
        locationService.delegate = self
        locationService.stopUserLocationService()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MRAK:用户定位
    func setUserLocation()  {
        locationService.startUserLocationService()
        _mapView?.showsUserLocation = false//先关闭显示的定位图层
        _mapView?.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView?.showsUserLocation = true//显示定位图层
    }
    
    //获取公交车路线信息
    func getBusDetailRoute(routeLine : BMKMassTransitRouteLine){
    
        dataArray.removeAllObjects()
        let size = routeLine.steps.count
        for i in 0..<size {
            let transitStep = routeLine.steps[i] as! BMKMassTransitStep
            
            for j in 0..<Int(transitStep.steps.count) {
                
                let subStep = transitStep.steps[j] as! BMKMassTransitSubStep
                //换成说明
                debugPrint(subStep.instructions)
                if (!subStep.instructions.isEmpty){
                    
                    dataArray.add(subStep.instructions)
                }
            }
        }
    }
    
    //获取驾车路线信息
    func getDrivingDetailRoute(routeLine : BMKDrivingRouteLine){
        dataArray.removeAllObjects()
        let size = routeLine.steps.count
        for i in 0..<size {
            let transitStep = routeLine.steps[i] as! BMKDrivingStep
            dataArray.add(transitStep.instruction)
    
        }
    }
    
    //获取步行路线信息
    func getWalkingDetailRoute(routeLine : BMKWalkingRouteLine){
        dataArray.removeAllObjects()
        let size = routeLine.steps.count
        for i in 0..<size {
            let transitStep = routeLine.steps[i] as! BMKWalkingStep
            dataArray.add(transitStep.instruction)
        }
    }
    
    //获取步行路线信息
    func getRidingDetailRoute(routeLine : BMKRidingRouteLine){
        dataArray.removeAllObjects()
        let size = routeLine.steps.count
        for i in 0..<size {
            let transitStep = routeLine.steps[i] as! BMKRidingStep
            dataArray.add(transitStep.instruction)
            
        }
    }

    //不通交通的规划路线
    func getMapRoute(){
        
        switch tag {
        case 101?:
            showBusRoutePlan()
            break
        case 102?:
            showCarRoutePlan()
            break
        case 103?:
            showWalkingRoutePlan()
            break
        case 104?:
            showRidingRoutePlan()
            break
        default:
            break
        }
    }
    //获取路线信息
    func getRouteDetailInfo(){
        
        bottomView?.type = tag!
        switch tag {
        case 101?:
            
            let route = pathHandler?.getBusDetailRoute(routeLine: busRoute!)
            let timeStr = pathHandler?.calculateTime(duration: busRoute!.duration)
            let distance = pathHandler?.calculateDistance(distance: Int(busRoute!.distance))
            let walkArray = (pathHandler?.getBusWaklingRoute(routeLine: busRoute!))!
            let walk = pathHandler?.calculateWalkingDistance(walkArray: walkArray)
            let walkDistance = pathHandler?.calculateDistance(distance: walk!)
            
            bottomView?.routerLabel?.text = "\(route!)"
            bottomView?.timeLabel?.text = "\(timeStr!)"
            let distanceStr = String(format:"%.2f",distance!)
            bottomView?.distanceLabel?.text = distanceStr + "km"
            let walkStr = String(format:"%.2f",walkDistance!)
            bottomView?.walkLabel?.text = walkStr + "km"
            bottomView?.routerLabel?.font = UIFont.systemFont(ofSize: 13)
            getBusDetailRoute(routeLine: busRoute!)
            break
        case 102?:
            
            let timeStr = pathHandler?.calculateTime(duration: drivingRoute!.duration)
            let distance = pathHandler?.calculateDistance(distance: Int(drivingRoute!.distance))
            
            bottomView?.timeLabel?.text = "\(timeStr!)"
            let distanceStr = String(format:"%.2f",distance!)
            bottomView?.distanceLabel?.text = distanceStr + "km"
            bottomView?.routerLabel?.text = drivingDesc
            getDrivingDetailRoute(routeLine: drivingRoute!)
            break

        case 103?:
            
            let timeStr = pathHandler?.calculateTime(duration: walkingRoute!.duration)
            let distance = pathHandler?.calculateDistance(distance: Int(walkingRoute!.distance))
            bottomView?.timeLabel?.textColor = StoreDetailImageTitle_Color
            bottomView?.timeLabel?.text = WalkTitle + "\(timeStr!)"
            let distanceStr = String(format:"%.2f",distance!)
            bottomView?.distanceLabel?.text = distanceStr + "km"
            
            getWalkingDetailRoute(routeLine: walkingRoute!)
            break

        case 104?:
            
            let timeStr = pathHandler?.calculateTime(duration: ridingRoute!.duration)
            let distance = pathHandler?.calculateDistance(distance: Int(ridingRoute!.distance))
            
            bottomView?.timeLabel?.text = RidingTitle + "\(timeStr!)"
            bottomView?.timeLabel?.textColor = StoreDetailImageTitle_Color
            let distanceStr = String(format:"%.2f",distance!)
            bottomView?.distanceLabel?.textColor = StoreDetailImageTitle_Color
            bottomView?.distanceLabel?.text = distanceStr + "km"
            getRidingDetailRoute(routeLine: ridingRoute!)
            break

        default:
            break
        }
    }

    //规划公交路线
    func showBusRoutePlan(){
        
        _mapView?.removeAnnotations(_mapView?.annotations)
        _mapView?.removeOverlays(_mapView?.overlays)
        
        var startCoorIsNull = true
        var startCoor = CLLocationCoordinate2D()//起点经纬度
        var endCoor   = CLLocationCoordinate2D()//终点经纬度
        
        let size = busRoute?.steps.count
        var planPointCount = 0
        // 轨迹点
        for i in 0..<size! {
            let transitStep = busRoute?.steps[i] as! BMKMassTransitStep
            
            for j in 0..<Int(transitStep.steps.count) {
                //添加annotation节点
                let subStep = transitStep.steps[j] as! BMKMassTransitSubStep

                let item = RouteAnnotation.init()
                item.coordinate = subStep.entraceCoor
                item.title = subStep.instructions
                item.type = 2
                _mapView?.addAnnotation(item)
                
                if startCoorIsNull {
                    startCoor = subStep.entraceCoor
                    startCoorIsNull = false
                }
                endCoor = subStep.exitCoor
                
                planPointCount = Int(subStep.pointsCount) + planPointCount
                
                //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
                if transitStep.isSubStep == false {//是子方案，只取第一条方案
                    break
                }
                else {
                    //是子路段，需要完整遍历transitStep.steps
                }
            }
            
        }
        let startAnnotation = RouteAnnotation.init()
        startAnnotation.coordinate = startCoor
        startAnnotation.title = "起点"
        startAnnotation.type = 0
        _mapView?.addAnnotation(startAnnotation)//添加起点标注
        
        let endAnnotation = RouteAnnotation.init()
        endAnnotation.coordinate = endCoor
        endAnnotation.title = "终点"
        endAnnotation.type = 1
        _mapView?.addAnnotation(endAnnotation)//添加终点标注
        
        
        var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCount)
        var index = 0
        for i in 0..<size! {
            let transitStep = busRoute?.steps[i] as! BMKMassTransitStep
            for j in 0..<Int(transitStep.steps.count) {
                let subStep = transitStep.steps[j] as! BMKMassTransitSubStep
                for k in 0..<Int(subStep.pointsCount) {
                    tempPoints[index].x = subStep.points[k].x
                    tempPoints[index].y = subStep.points[k].y
                    index += 1
                }
                
                //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
                if transitStep.isSubStep == false {//是子方案，只取第一条方案
                    break
                }
                else {
                    //是子路段，需要完整遍历transitStep.steps
                }
            }
            
        }
        // 通过 points 构建 BMKPolyline
        let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCount))
        _mapView?.add(polyLine)  // 添加路线 overlay
        mapViewFitPolyLine(polyLine)
        
    }
    
    //规划驾车路线
    func showCarRoutePlan(){
        
        _mapView?.removeAnnotations(_mapView?.annotations)
        _mapView?.removeOverlays(_mapView?.overlays)
        
        let size = drivingRoute?.steps.count
        var planPointCounts = 0
        for i in 0..<size! {
            let transitStep = drivingRoute?.steps[i] as! BMKDrivingStep
            if i == 0 {
                let item = RouteAnnotation()
                item.coordinate = (drivingRoute?.starting.location)!
                item.title = "起点"
                item.type = 0
                _mapView?.addAnnotation(item)  // 添加起点标注
            }
            if i == size! - 1 {
                let item = RouteAnnotation()
                item.coordinate = (drivingRoute?.terminal.location)!
                item.title = "终点"
                item.type = 1
                _mapView?.addAnnotation(item)  // 添加终点标注
            }
            
            // 添加 annotation 节点
            let item = RouteAnnotation()
            item.coordinate = transitStep.entrace.location
            item.title = transitStep.instruction
            item.degree = Int(transitStep.direction) * 30
            item.type = 4
            _mapView?.addAnnotation(item)
            
            // 轨迹点总数累计
            planPointCounts = Int(transitStep.pointsCount) + planPointCounts
        }
        
        // 添加途径点
        if drivingRoute?.wayPoints != nil {
            for tempNode in drivingRoute?.wayPoints as! [BMKPlanNode] {
                let item = RouteAnnotation()
                item.coordinate = tempNode.pt
                item.type = 5
                item.title = tempNode.name
                _mapView?.addAnnotation(item)
            }
        }
        
        // 轨迹点
        var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
        var i = 0
        for j in 0..<size! {
            let transitStep = drivingRoute?.steps[j] as! BMKDrivingStep
            for k in 0..<Int(transitStep.pointsCount) {
                tempPoints[i].x = transitStep.points[k].x
                tempPoints[i].y = transitStep.points[k].y
                i += 1
            }
        }
        
        // 通过 points 构建 BMKPolyline
        let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
        // 添加路线 overlay
        _mapView?.add(polyLine)
        mapViewFitPolyLine(polyLine)
        
    }
    
    
    //规划步行路线
    func showWalkingRoutePlan(){
        
        _mapView?.removeAnnotations(_mapView?.annotations)
        _mapView?.removeOverlays(_mapView?.overlays)
        
        let size = walkingRoute?.steps.count
        var planPointCounts = 0
        for i in 0..<size! {
            let transitStep = walkingRoute?.steps[i] as! BMKWalkingStep
            if i == 0 {
                let item = RouteAnnotation()
                item.coordinate = (walkingRoute?.starting.location)!
                item.title = "起点"
                item.type = 0
                _mapView?.addAnnotation(item)  // 添加起点标注
            }
            if i == size! - 1 {
                let item = RouteAnnotation()
                item.coordinate = (walkingRoute?.terminal.location)!
                item.title = "终点"
                item.type = 1
                _mapView?.addAnnotation(item)  // 添加终点标注
            }
            // 添加 annotation 节点
            let item = RouteAnnotation()
            item.coordinate = transitStep.entrace.location
            item.title = transitStep.entraceInstruction
            item.degree = Int(transitStep.direction) * 30
            item.type = 4
            _mapView?.addAnnotation(item)
            
            // 轨迹点总数累计
            planPointCounts = Int(transitStep.pointsCount) + planPointCounts
        }
        
        // 轨迹点
        var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
        var i = 0
        for j in 0..<size! {
            let transitStep = walkingRoute?.steps[j] as! BMKWalkingStep
            for k in 0..<Int(transitStep.pointsCount) {
                tempPoints[i].x = transitStep.points[k].x
                tempPoints[i].y = transitStep.points[k].y
                i += 1
            }
        }
        
        // 通过 points 构建 BMKPolyline
        let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
        _mapView?.add(polyLine)  // 添加路线 overlay
        mapViewFitPolyLine(polyLine)
        
    }
    
    //规划骑行路线
    func showRidingRoutePlan(){
        
        _mapView?.removeAnnotations(_mapView?.annotations)
        _mapView?.removeOverlays(_mapView?.overlays)
        
        let size = ridingRoute?.steps.count
        var planPointCounts = 0
        for i in 0..<size! {
            let transitStep = ridingRoute?.steps[i] as! BMKRidingStep
            if i == 0 {
                let item = RouteAnnotation()
                item.coordinate = (ridingRoute?.starting.location)!
                item.title = "起点"
                item.type = 0
                _mapView?.addAnnotation(item)  // 添加起点标注
            }
            if i == size! - 1 {
                let item = RouteAnnotation()
                item.coordinate = (ridingRoute?.terminal.location)!
                item.title = "终点"
                item.type = 1
                _mapView?.addAnnotation(item)  // 添加终点标注
            }
            // 添加 annotation 节点
            let item = RouteAnnotation()
            item.coordinate = transitStep.entrace.location
            item.title = transitStep.entraceInstruction
            item.degree = Int(transitStep.direction) * 30
            item.type = 4
            _mapView?.addAnnotation(item)
            
            // 轨迹点总数累计
            planPointCounts = Int(transitStep.pointsCount) + planPointCounts
        }
        
        // 轨迹点
        var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
        var i = 0
        for j in 0..<size! {
            let transitStep = ridingRoute?.steps[j] as! BMKRidingStep
            for k in 0..<Int(transitStep.pointsCount) {
                tempPoints[i].x = transitStep.points[k].x
                tempPoints[i].y = transitStep.points[k].y
                i += 1
            }
        }
        
        // 通过 points 构建 BMKPolyline
        let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
        _mapView?.add(polyLine)  // 添加路线 overlay
        mapViewFitPolyLine(polyLine)
        
    }
    //根据polyline设置地图范围
    func mapViewFitPolyLine(_ polyline: BMKPolyline!) {
        if polyline.pointCount < 1 {
            return
        }
        
        let pt = polyline.points[0]
        var leftTopX = pt.x
        var leftTopY = pt.y
        var rightBottomX = pt.x
        var rightBottomY = pt.y
        
        for i in 1..<polyline.pointCount {
            let pt = polyline.points[Int(i)]
            leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
            leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
            rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
            rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
        }
        
        let rect = BMKMapRectMake(leftTopX, leftTopY, rightBottomX - leftTopX, rightBottomY - leftTopY)
        _mapView?.visibleMapRect = rect
    }
    
    //创建地图
    func mapView(){
        
        locationService = BMKLocationService()
        _mapView = BMKMapView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height))
        self.view.addSubview(_mapView!)
        _mapView?.zoomLevel = zoomSize
        addMapScaleBar()
        
        handler = JYD_MapHandler.init()
        handler?.delegate = self
        handler?.vc = self
        
        if UI_IS_IPHONE5 {
            handler?.addZoomView(CGPoint.init(x: _k_w - 60, y: _k_h / 2 - 60))
        }else{
            
            handler?.addZoomView(CGPoint.init(x: _k_w - 60, y: _k_h / 2))
        }
    }
    
    //设置比例尺位置
    func addMapScaleBar()  {
        _mapView?.showMapScaleBar = true
        
        var height = 0
        
        height = Int((_mapView?.frame.height)! - 280)
        if UI_IS_IPONE6 {
            
            height = Int((_mapView?.frame.height)! - 260)
        }
        
        _mapView?.mapScaleBarPosition = CGPoint(x: 10, y: height)
        _mapView?.mapPadding = UIEdgeInsetsMake(0, 0, 28, 0)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //具体路线显示或是隐藏
    func directionImage(isDown: Bool) {
        if isDown {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                if UI_IS_IPHONEX {
                    self.bottomView?.snp.updateConstraints({ (make) in
                        make.height.equalTo(100)
                    })
                }else{
                    self.bottomView?.snp.updateConstraints({ (make) in
                        make.height.equalTo(88)
                    })
                }
                self.bottomView?.directionButton?.setImage(UIImage(named:"up_icon"), for: .normal)
            }) { (complication) in
            }
        
        }else{
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                if UI_IS_IPHONEX {
                    self.bottomView?.snp.updateConstraints({ (make) in
                        make.height.equalTo(228)
                    })
                }else{
                    self.bottomView?.snp.updateConstraints({ (make) in
                        make.height.equalTo(238)
                    })
                }
                self.bottomView?.directionButton?.setImage(UIImage(named:"down_icon"), for: .normal)
            }) { (complication) in
            }
            
        }
    }
    
    //MARK:JYD_MapHandlerDelegate 地图控件
    func addRepositionButtonClick() {

    }
    
    func addMapEnlargedButtonClick() {
        zoomSize += 1
        _mapView?.zoomLevel = zoomSize
    }
    
    func addMapShrinkButtonClick() {
        zoomSize -= 1
        _mapView?.zoomLevel = zoomSize
    }
    
    /**
     *地图初始化完毕时会调用此接口
     *@param mapView 地图View
     */
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        getMapRoute()
    }
    
    // MARK: - BMKMapViewDelegate
    
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    

    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {

        print("根据anntation生成对应的View")
        if let routeAnnotation = annotation as! RouteAnnotation? {
            return getViewForRouteAnnotation(routeAnnotation)
        }
        return nil
    }
    
    /**
     *根据overlay生成对应的View
     *@param mapView 地图View
     *@param overlay 指定的overlay
     *@return 生成的覆盖物View
     */
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay as! BMKPolyline? != nil {
            let polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView?.strokeColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
            polylineView?.lineWidth = 5
            return polylineView
        }
        return nil
    }
    
    // MARK: -
    
    func getViewForRouteAnnotation(_ routeAnnotation: RouteAnnotation!) -> BMKAnnotationView? {
        var view: BMKAnnotationView?
        
        var imageName: String?
        switch routeAnnotation.type {
        case 0:
            imageName = "nav_start"
        case 1:
            imageName = "nav_end"
        case 2:
            imageName = "nav_bus"
        case 3:
            imageName = "nav_rail"
        case 4:
            imageName = "direction"
        case 5:
            imageName = "nav_waypoint"
        default:
            return nil
        }
        let identifier = "\(String(describing: imageName))_annotation"
        view = _mapView?.dequeueReusableAnnotationView(withIdentifier: identifier)
        if view == nil {
            view = BMKAnnotationView(annotation: routeAnnotation, reuseIdentifier: identifier)
            view?.centerOffset = CGPoint(x: 0, y: -(view!.frame.size.height * 0.5))
            view?.canShowCallout = true
        }
        
        view?.annotation = routeAnnotation
        
        let bundlePath = (Bundle.main.resourcePath)! + "/mapapi.bundle/"
        let bundle = Bundle(path: bundlePath)
        var tmpBundle : String?
        tmpBundle = (bundle?.resourcePath)! + "/images/icon_\(imageName!).png"
        if let imagePath = tmpBundle {
            var image = UIImage(contentsOfFile: imagePath)
            if routeAnnotation.type == 4 {
                image = imageRotated(image, degrees: routeAnnotation.degree)
            }
            if image != nil {
                view?.image = image
            }
        }
        
        return view
    }
    
    //旋转图片
    func imageRotated(_ image: UIImage!, degrees: Int!) -> UIImage {
        let width = image.cgImage?.width
        let height = image.cgImage?.height
        let rotatedSize = CGSize(width: width!, height: height!)
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap = UIGraphicsGetCurrentContext();
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        bitmap?.rotate(by: CGFloat(Double(degrees) * Double.pi / 180.0));
        bitmap?.rotate(by: CGFloat(Double.pi));
        bitmap?.scaleBy(x: -1.0, y: 1.0);
        bitmap?.draw(image.cgImage!, in: CGRect(x: -rotatedSize.width/2, y: -rotatedSize.height/2, width: rotatedSize.width, height: rotatedSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
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

        _mapView?.updateLocationData(userLocation)
        
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
