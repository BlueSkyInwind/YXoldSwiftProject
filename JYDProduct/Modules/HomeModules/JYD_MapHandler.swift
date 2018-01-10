//
//  JYD_MapHandler.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit
import MapKit

enum JYD_StartExternalMapsType {
   case MapWalk
   case MapRide
   case MapDriving
   case MapTransit
}

@objc protocol JYD_MapHandlerDelegate: NSObjectProtocol{
   
    func addRepositionButtonClick()
    func addMapEnlargedButtonClick()
    func addMapShrinkButtonClick()
    
}

class JYD_MapHandler: BaseHandler {

    var repositionBtn:UIButton?
    var vc:UIViewController?
    var delegate:JYD_MapHandlerDelegate?
    
    override init() {
        super.init()
        
    }
    //MARK:地图重新定位按钮
    func addRepositionBtn(_ point:CGPoint)  {
        repositionBtn = UIButton.init(type: UIButtonType.custom)
        repositionBtn?.frame = CGRect.init(x: point.x, y: point.y, width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 38))
        repositionBtn?.setBackgroundImage(UIImage.init(named: "repositionBtn_Icon"), for: UIControlState.normal)
        repositionBtn?.addTarget(self, action: #selector(addRepositionBtnClick), for: UIControlEvents.touchUpInside)
        vc?.view.addSubview(repositionBtn!)
    }
    
    @objc func addRepositionBtnClick() {
        if self.delegate != nil {
            self.delegate?.addRepositionButtonClick()
        }
    }
    
    //MARK:地图缩放按钮
    func addZoomView(_ point:CGPoint)  {
        
        let zoomView = UIView.init(frame: CGRect.init(x: point.x, y: point.y, width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 77)))
        vc?.view.addSubview(zoomView)

        let enlargedBtn = UIButton.init(type: UIButtonType.custom)
        enlargedBtn.frame = CGRect.init(x: 0, y: 0, width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 38))
        enlargedBtn.setBackgroundImage(UIImage.init(named: "mapEnlarge_Icon"), for: UIControlState.normal)
        enlargedBtn.addTarget(self, action: #selector(addEnlargedBtnClick), for: UIControlEvents.touchUpInside)
        zoomView.addSubview(enlargedBtn)
        
        let shrinkBtn = UIButton.init(type: UIButtonType.custom)
        shrinkBtn.frame = CGRect.init(x: 0, y: APPTool.obtainDisplaySize(size: 39), width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 38))
        shrinkBtn.setBackgroundImage(UIImage.init(named: "mapShrink_Icon"), for: UIControlState.normal)
        shrinkBtn.addTarget(self, action: #selector(addShrinkBtnClick), for: UIControlEvents.touchUpInside)
        zoomView.addSubview(shrinkBtn)
        
    }
    
    @objc func addEnlargedBtnClick() {
        if self.delegate != nil {
            self.delegate?.addMapEnlargedButtonClick()
        }
    }
    
    @objc func addShrinkBtnClick() {
        if self.delegate != nil {
            self.delegate?.addMapShrinkButtonClick()
        }
    }
    
    //MARK:启动外部地图
    func startExternalMaps(_ externalMapsType:JYD_StartExternalMapsType,fromLocation:CLLocationCoordinate2D,fromName:String,toLocation:CLLocationCoordinate2D,toName:String)  {
        let alertSheetVC = UIAlertController.init(title: nil, message: StartMapSheetMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            let alertActionOne = UIAlertAction.init(title: "高德地图", style: UIAlertActionStyle.default, handler: { (action) in
                self.startExternalGaodeMaps(externalMapsType, fromLocation: fromLocation, fromName:fromName, toLocation: toLocation,toName: toName)
            })
            alertSheetVC.addAction(alertActionOne)
        }
        
        let alertActionTwo = UIAlertAction.init(title: "本地地图", style: UIAlertActionStyle.default, handler: { (action) in
            self.startExternalAppleMaps(externalMapsType, fromLocation: fromLocation,fromName:fromName, toLocation: toLocation,toName: toName)
        })
        alertSheetVC.addAction(alertActionTwo)
        
         if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
            let alertActionTwo = UIAlertAction.init(title: "百度地图", style: UIAlertActionStyle.default, handler: { (action) in
                self.startExternalBMKMaps(externalMapsType, fromLocation: fromLocation, fromName:fromName,toLocation: toLocation,toName: toName)
            })
            alertSheetVC.addAction(alertActionTwo)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        alertSheetVC.addAction(cancelAction)
        vc?.present(alertSheetVC, animated: true, completion: nil)
    }
    //MARK:高德地图
    func startExternalGaodeMaps(_ externalMapsType:JYD_StartExternalMapsType,fromLocation:CLLocationCoordinate2D,fromName:String,toLocation:CLLocationCoordinate2D,toName:String)  {
        
        var routeType = 1  //高德中 0，驾车  1，公交  2，步行  3，骑行 （骑行仅在V788以上版本支持）
        
        switch externalMapsType {
        case .MapWalk:
            routeType = 2
            break
        case .MapDriving:
            routeType = 0
            break
        case .MapTransit:
            routeType = 1
            break
        case .MapRide:
            routeType = 3
            break
        }
        
        let aMapUrl = "iosamap://path?sourceApplication=\(appDisplayName)&sid=BGVIS1&slat=\(fromLocation.latitude)&slon=\(fromLocation.longitude)&sname=我的位置&did=BGVIS2&dlat=\(toLocation.latitude)&dlon=\(toLocation.longitude)&dname=nil&dev=0&t=\(routeType)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if #available(iOS 10.0, *){
            UIApplication.shared.open(URL.init(string: aMapUrl!)!, options: [:], completionHandler: { (isSuccess) in
                
            })
        }else{
            UIApplication.shared.openURL(URL.init(string: aMapUrl!)!)
        }
    }
     //MARK:本地地图
    func startExternalAppleMaps(_ externalMapsType:JYD_StartExternalMapsType,fromLocation:CLLocationCoordinate2D,fromName:String,toLocation:CLLocationCoordinate2D,toName:String)  {
        
        let currentLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: fromLocation, addressDictionary: [:]))
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: toLocation, addressDictionary: [:]))
        let items = [currentLocation,toLocation]
        let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:NSNumber.init(value: 0), MKLaunchOptionsShowsTrafficKey:true] as [String : Any]
        MKMapItem.openMaps(with: items, launchOptions: options)
        
    }
    
     //MARK:百度地图
    func startExternalBMKMaps(_ externalMapsType:JYD_StartExternalMapsType,fromLocation:CLLocationCoordinate2D,fromName:String,toLocation:CLLocationCoordinate2D,toName:String) {
    
        let appScheme = "baidumapsdk://mapsdk.baidu.com"
        
        //初始化起点节点
        let start = BMKPlanNode()
        //指定起点经纬度
        start.pt = fromLocation
        //指定起点名称
        start.name = "西直门"

        //初始化终点节点
        let end = BMKPlanNode()
        //指定终点经纬度
        end.pt = toLocation
        //指定终点名称
        end.name = "天安门"
        
        switch externalMapsType {
        case .MapWalk:
            let opt = BMKOpenWalkingRouteOption()
            opt.appScheme = appScheme
            //指定起点
            opt.startPoint = start
            //指定终点
            opt.endPoint = end
            let code = BMKOpenRoute.openBaiduMapWalkingRoute(opt)
            DPrint(message: code)
             break
        case .MapRide:
            // 初始化调启导航的参数管理类
            let parameter = BMKNaviPara()
            //指定起点
            parameter.startPoint = start
            // 指定终点
            parameter.endPoint = end
            BMKNavigation.openBaiduMapRide(parameter)
            break
        case .MapDriving:
            let opt = BMKOpenDrivingRouteOption()
            opt.appScheme = appScheme
            //指定起点
            opt.startPoint = start
            //指定终点
            opt.endPoint = end
            let code = BMKOpenRoute.openBaiduMapDrivingRoute(opt)
            DPrint(message: code)
            break
        case .MapTransit:
            let opt = BMKOpenTransitRouteOption()
            opt.appScheme = appScheme
            //指定起点
            opt.startPoint = start
            //指定终点
            opt.endPoint = end
            opt.openTransitPolicy = BMK_OPEN_TRANSIT_RECOMMAND
            let code = BMKOpenRoute.openBaiduMapTransitRoute(opt)
            DPrint(message: code)
            break
        default:
            break
        }
    }
    
    
    
    
    
    

}
