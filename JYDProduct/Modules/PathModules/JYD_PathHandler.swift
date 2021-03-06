//
//  JYD_PathHandler.swift
//  JYDProduct
//
//  Created by sxp on 2018/1/10.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_PathHandler: BaseHandler {

    override init() {
        super.init()
        
    }
    
    //累计加步行的总路程
    func calculateWalkingDistance(walkArray: NSMutableArray)->Int{
        
        var total = 0
        
        for i in 0..<walkArray.count {
            let str = walkArray[i] as! String
            var distance : NSMutableString
            distance = ""
            for c in str {
                if c > "0" && c < "9"{
                    
                    let str1 = String(c)
                    distance.append(str1)
                    
                }
            }
            let dis = Int(distance as String)
            if dis != nil {
                
                total += dis!
            }
        }
        
//        print(total)
        return total
    }
    
    //计算总路程
    func calculateDistance(distance: Int)->Double{
        
        var distanceStr : Double
        distanceStr = 0.00
        
        let str = (Double)(distance / 1000)
        var  str1 = 0.00
        if distance % 1000 != 0 {
            str1 = Double(Int(distance) - Int(str * 1000))
        }
        
        let str2 = str1 * 0.001
        
        distanceStr = str + str2
        
        return distanceStr
    }
    
    //计算总用时
    func calculateTime(duration: BMKTime)->NSString{
        
        let timeStr : NSMutableString
        timeStr = ""
        
        if duration.dates != 0 {
            timeStr.append("\(duration.dates)")
            timeStr.append("天")
        }
        if duration.hours != 0 {
            timeStr.append("\(duration.hours)")
            timeStr.append("小时")
        }
        if duration.minutes != 0 {
            timeStr.append("\(duration.minutes)")
            timeStr.append("分钟")
        }
        if duration.dates == 0 && duration.hours == 0 && duration.minutes == 0 && duration.seconds != 0 {
            
            timeStr.append("\(duration.seconds)")
            timeStr.append("秒")
        }
//        if duration.seconds != 0 {
//            timeStr.append("\(duration.seconds)")
//            timeStr.append("秒")
//        }
        return timeStr
    }
    
    //自驾排序
    func getCarDetailRoute(dataArray:NSMutableArray){
        
        for index in 0..<dataArray.count{
            let routeLine = dataArray[index] as! BMKDrivingRouteLine
            let time = routeLine.duration.dates * 24 * 3600 + routeLine.duration.hours * 3600 + routeLine.duration.minutes * 60 + routeLine.duration.seconds
            for k in index+1..<dataArray.count{
                let routeLine1 = dataArray[k] as! BMKDrivingRouteLine
                let time1 = routeLine1.duration.dates * 24 * 3600 + routeLine1.duration.hours * 3600 + routeLine1.duration.minutes * 60 + routeLine1.duration.seconds
                if time > time1{
                    
                    let temp = dataArray[index]
                    dataArray[index] = dataArray[k]
                    dataArray[k] = temp
                    
                }
            }
        }
    }
    
    //获取公交车路线信息
    func getBusDetailRoute(routeLine : BMKMassTransitRouteLine)->NSString{
        
        let routeStr : NSMutableString
        routeStr = ""
        let size = routeLine.steps.count
        for i in 0..<size {
            let transitStep = routeLine.steps[i] as! BMKMassTransitStep
            
            for j in 0..<Int(transitStep.steps.count) {
                
                let subStep = transitStep.steps[j] as! BMKMassTransitSubStep
                //换成说明
                //debugPrint(subStep.instructions)
                //路段类型
                //debugPrint(subStep.stepType)
                if subStep.stepType != BMK_TRANSIT_WAKLING{//BMK_TRANSIT_WAKLING为步行
                    if (subStep.vehicleInfo.name != nil){
//                        debugPrint(subStep.vehicleInfo.name)
                        routeStr.append(subStep.vehicleInfo.name)
                        if i == size - 2 {
                            
                            continue
                        }
                        routeStr.append("—")
                    }
                }
            }
        }
        return routeStr
    }
    
    //获取公交车路线步行信息
    func getBusWaklingRoute(routeLine : BMKMassTransitRouteLine)->NSMutableArray{
        
        let waklArray : NSMutableArray = []

        let size = routeLine.steps.count
        for i in 0..<size {
            let transitStep = routeLine.steps[i] as! BMKMassTransitStep
            
            for j in 0..<Int(transitStep.steps.count) {
                
                let subStep = transitStep.steps[j] as! BMKMassTransitSubStep
                //路段类型
                if subStep.stepType == BMK_TRANSIT_WAKLING{//BMK_TRANSIT_WAKLING为步行
                    
                    waklArray.add(subStep.instructions)
                }
            }
        }
        return waklArray
    }
    
    //路线规划提示错误信息
    func setErrorMessage(errorCode : BMKSearchErrorCode) ->String{
        
        switch errorCode {
        case BMK_SEARCH_AMBIGUOUS_KEYWORD:
        
            return "检索词有岐义"
        case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
            return "检索地址有岐义"
        case BMK_SEARCH_NOT_SUPPORT_BUS:
            return "该城市不支持公交搜索"
        case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
            return "该城市不支持公交搜索"
        case BMK_SEARCH_RESULT_NOT_FOUND:
            return "没有找到检索结果"
        case BMK_SEARCH_ST_EN_TOO_NEAR:
            return "起终点太近"
        case BMK_SEARCH_KEY_ERROR,BMK_SEARCH_NETWOKR_ERROR,BMK_SEARCH_NETWOKR_TIMEOUT,BMK_SEARCH_INDOOR_ID_ERROR,BMK_SEARCH_FLOOR_ERROR,BMK_SEARCH_PARAMETER_ERROR:
            return "网络连接超时,请稍后重试"
        case BMK_SEARCH_INDOOR_ROUTE_NO_IN_BUILDING:
            return "起终点不在支持室内路线的室内图内"
        case BMK_SEARCH_INDOOR_ROUTE_NO_IN_SAME_BUILDING:
            return "起终点不在同一个室内"
        case BMK_SEARCH_PERMISSION_UNFINISHED:
            return "还未完成鉴权，请在鉴权通过后重试"
        
        default:
            break
            
        }
        
        return ""
    }
    
    
    //计算tab的高度
    func calculatePathDetailTabHeight(datarray : NSMutableArray)->CGFloat{
        
        var height : CGFloat = 0
        for index in 0..<3 {
        
            let str = datarray[index] as! NSString
            let length = str.boundingRect(with: CGSize.init(width: _k_w - 81, height: _k_h), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [:], context: nil).height
            if length > 27{
                
                height += length + 30
            }else{
                
                height += 50
            }
        }
        return height
    }
    
    func calculatePathDetailTabCellHeight(cellContent : String)-> CGFloat{
        
        let length = cellContent.boundingRect(with: CGSize.init(width: _k_w - 81, height: _k_h), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [:], context: nil).height
        
        return length
    }
    
    //MARK:距离转化地图缩放等级
    func distanceTransformToLevel(_ distanceStr:String) -> Float {
        var level = 14
        let distance = Int(distanceStr)!
        if distance >= 10 &&  distance <= 20 {
            level = 13
            if UI_IS_IPHONE5 {
                level = 11
            }
        }
        
        if distance > 20 &&  distance <= 30 {
            level = 12
            if UI_IS_IPHONE5 {
                level = 10
            }
        }
        
        if distance > 30 {
            level = 11
            if UI_IS_IPHONE5 {
                level = 9
            }
        }
        return Float(level)
    }
    
}
