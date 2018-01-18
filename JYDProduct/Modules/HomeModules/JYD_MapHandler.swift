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
   case MapAnnotation
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
    
    //MRAK:计算地图上两点距离
    func distanceBetweenPoint(coordinateOne:CLLocationCoordinate2D,coordinateTwo:CLLocationCoordinate2D) -> CLLocationDistance {
        let pointOne = BMKMapPointForCoordinate(coordinateOne)
        let pointTwo = BMKMapPointForCoordinate(coordinateTwo)
        let distance = BMKMetersBetweenMapPoints(pointOne, pointTwo)
        return distance
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
        //百度坐标转火星坐标
        let fromCoordinate = BMKCoordinateToGCJ02(coor: fromLocation)
        let toCoordinate = BMKCoordinateToGCJ02(coor: toLocation)
    
        var routeType = 1  //高德中 0，驾车  1，公交  2，步行  3，骑行 （骑行仅在V788以上版本支持）
        var isRouter = true
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
        case .MapAnnotation:
            isRouter = false
            break
        }
        
        var aMapUrl = ""
        if isRouter {
            aMapUrl = "iosamap://path?sourceApplication=\(appDisplayName)&sid=BGVIS1&slat=\(fromCoordinate.latitude)&slon=\(fromCoordinate.longitude)&sname=我的位置&did=BGVIS2&dlat=\(toCoordinate.latitude)&dlon=\(toCoordinate.longitude)&dname=\(toName)&dev=0&m=0&t=\(routeType)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }else{
            aMapUrl = "iosamap://viewMap?sourceApplication=\(appDisplayName)&poiname=\(toName)&lat=\(toCoordinate.latitude)&lon=\(toCoordinate.longitude)&dev=0".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        
        if #available(iOS 10.0, *){
            UIApplication.shared.open(URL.init(string: aMapUrl)!, options: [:], completionHandler: { (isSuccess) in
            })
        }else{
            UIApplication.shared.openURL(URL.init(string: aMapUrl)!)
        }
    }
    
     //MARK:本地地图
    func startExternalAppleMaps(_ externalMapsType:JYD_StartExternalMapsType,fromLocation:CLLocationCoordinate2D,fromName:String,toLocation:CLLocationCoordinate2D,toName:String)  {
        
        //百度坐标转本机坐标
        let fromCoordinate = BMKCoordinateToGCJ02(coor: fromLocation)
        let toCoordinate = BMKCoordinateToGCJ02(coor: toLocation)
        
        let currentLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: fromCoordinate, addressDictionary: [:]))
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: toCoordinate, addressDictionary: [:]))
        var items = [currentLocation,toLocation]
        
        var options = [:] as [String : Any]
        switch externalMapsType {
        case .MapWalk:
            options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsMapTypeKey:NSNumber.init(value: 0), MKLaunchOptionsShowsTrafficKey:true]
            break
        case .MapDriving:
            options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:NSNumber.init(value: 0), MKLaunchOptionsShowsTrafficKey:true]
            break
        case .MapTransit:
            if #available(iOS 9.0, *) {
                options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit,MKLaunchOptionsMapTypeKey:NSNumber.init(value: 0), MKLaunchOptionsShowsTrafficKey:true]
            } else {
                options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:NSNumber.init(value: 0), MKLaunchOptionsShowsTrafficKey:true]
            }
            break
        case .MapRide:
            options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsMapTypeKey:NSNumber.init(value: 0), MKLaunchOptionsShowsTrafficKey:true]
            break
        case .MapAnnotation:
            items = [toLocation]
            options = [:]
            break
        }
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
        start.name = fromName

        //初始化终点节点
        let end = BMKPlanNode()
        //指定终点经纬度
        end.pt = toLocation
        //指定终点名称
        end.name = toName
        
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
        case .MapAnnotation:
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
        }
    }
    
    //MARK:将base64的经纬度转化
    func ConvertBase64ToCoor(dic:NSDictionary) -> CLLocationCoordinate2D {
        let baseX = dic["x"]
        let baseY = dic["y"]
        let decodedDataX:NSData? = NSData(base64Encoded:baseX as! String, options: NSData.Base64DecodingOptions())
        let decodedX = NSString(data: decodedDataX! as Data, encoding: String.Encoding.utf8.rawValue)!
        
        let decodedDataY:NSData? = NSData(base64Encoded:baseY as! String, options: NSData.Base64DecodingOptions())
        let decodedY = NSString(data: decodedDataY! as Data, encoding: String.Encoding.utf8.rawValue)!
        
        let coordinate = CLLocationCoordinate2D.init(latitude: decodedY.doubleValue, longitude: decodedX.doubleValue)
        return coordinate
    }
    
    //MARK:百度坐标转火星坐标
     func BMKCoordinateToGCJ02(coor:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
       
        let  x_pi = Double.pi * 3000.0 / 180.0
        let x = coor.longitude - 0.0065;
        let y = coor.latitude - 0.006;
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
        let gglon = z * cos(theta);
        let gglat = z * sin(theta);
        let coordinate = CLLocationCoordinate2D.init(latitude: gglat, longitude: gglon)
        return coordinate
    
    }
    
    
    
    

}
