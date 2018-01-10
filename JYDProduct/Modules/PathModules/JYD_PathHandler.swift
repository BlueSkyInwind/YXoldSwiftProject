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
    
}
