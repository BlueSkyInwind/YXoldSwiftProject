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
        
        print(total)
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
        if duration.seconds != 0 {
            timeStr.append("\(duration.seconds)")
            timeStr.append("秒")
        }
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
                debugPrint(subStep.instructions)
                //路段类型
                debugPrint(subStep.stepType)
                if subStep.stepType != BMK_TRANSIT_WAKLING{//BMK_TRANSIT_WAKLING为步行
                    if (subStep.vehicleInfo.name != nil){
                        debugPrint(subStep.vehicleInfo.name)
                        routeStr.append(subStep.vehicleInfo.name)
                        if i == size - 2 {
                            
                            continue
                        }
                        routeStr.append("--")
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
                debugPrint(subStep.stepType)
                if subStep.stepType == BMK_TRANSIT_WAKLING{//BMK_TRANSIT_WAKLING为步行
                    
                    waklArray.add(subStep.instructions)
                }
            }
        }
        return waklArray
    }
}
