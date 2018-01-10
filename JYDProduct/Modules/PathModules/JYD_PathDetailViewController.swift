//
//  JYD_PathDetailViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_PathDetailViewController: BaseViewController ,BMKMapViewDelegate,JYD_SelectPathDetailRouterViewDelegate,JYD_MapHandlerDelegate{
    
    
    var _mapView:BMKMapView?
    var zoomSize:Float = 14
    var handler:JYD_MapHandler?
    var busRoute: BMKMassTransitRouteLine?
    var drivingRoute: BMKDrivingRouteLine?
    var walkingRoute: BMKWalkingRouteLine?
    var ridingRoute: BMKRidingRouteLine?
    var dataArray : NSMutableArray = []
    var tag : Int?
    
    var bottomView : JYD_SelectPathDetailRouterView?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "急用达"
        addBackItem()
        mapView()
        
        bottomView = JYD_SelectPathDetailRouterView()
        bottomView?.delegate = self
        bottomView?.routerLabel?.text = "地铁10号线--地铁2号线--地铁9号线"
        bottomView?.timeLabel?.text = "1小时26分钟"
        bottomView?.distanceLabel?.text = "10.4km"
        bottomView?.walkLabel?.text = "步行1.3km"
        self.view.addSubview(bottomView!)
        bottomView?.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.height.equalTo(228)
        }
        
        getRouteDetailInfo()
        bottomView?.dataArray = dataArray
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
        
    }
    
    func getRouteDetailInfo(){
        switch tag {
        case 101?:
            getBusDetailRoute(routeLine: busRoute!)
        case 102?:
            getDrivingDetailRoute(routeLine: drivingRoute!)
        case 103?:
            getWalkingDetailRoute(routeLine: walkingRoute!)
        case 104?:
            getRidingDetailRoute(routeLine: ridingRoute!)
        default:
            break
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func mapView(){
        
        _mapView = BMKMapView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height))
        self.view.addSubview(_mapView!)
        _mapView?.zoomLevel = zoomSize
        
        addMapScaleBar()
        
        handler = JYD_MapHandler.init()
        handler?.delegate = self
        handler?.vc = self
        handler?.addRepositionBtn(CGPoint.init(x: 10, y: _k_h / 2))
        handler?.addZoomView(CGPoint.init(x: _k_w - 60, y: _k_h / 2))
    }
    
    func addMapScaleBar()  {
        _mapView?.showMapScaleBar = true
        _mapView?.mapScaleBarPosition = CGPoint(x: 10, y: (_mapView?.frame.height)! - 280)
        _mapView?.mapPadding = UIEdgeInsetsMake(0, 0, 28, 0)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func directionImage(isDown: Bool) {
        if isDown {
            
            bottomView?.snp.updateConstraints({ (make) in
                make.height.equalTo(78)
            })
            
            bottomView?.directionButton?.setImage(UIImage(named:"up_icon"), for: .normal)
            
        }else{
            
            bottomView?.snp.updateConstraints({ (make) in
                make.height.equalTo(228)
            })
            
            bottomView?.directionButton?.setImage(UIImage(named:"down_icon"), for: .normal)
        }
    }
    
    //MARK:JYD_MapHandlerDelegate 地图控件
    func addRepositionButtonClick() {
        DPrint(message: "重新定位")
        
    }
    
    func addMapEnlargedButtonClick() {
        zoomSize += 1
        _mapView?.zoomLevel = zoomSize
    }
    
    func addMapShrinkButtonClick() {
        zoomSize -= 1
        _mapView?.zoomLevel = zoomSize
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
