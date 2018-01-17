//
//  JYD_GlobalViewModel.swift
//  JYDProduct
//
//  Created by admin on 2018/1/17.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import Foundation

typealias ReturnDataValue<T> = ( _ resultObject: T) -> Void
typealias ReturnFailure = ( _ error: Error) -> Void


func obtainStoreListLocationInfo(_ userLocation:CLLocationCoordinate2D, successResponse: @escaping ReturnDataValue<BaseModel<Array<Any>>>, errorResponse: @escaping ReturnFailure){
    
    var paramObject = StoreLocationListParam()
    paramObject.lng = userLocation.longitude
    paramObject.lat = userLocation.latitude
    let paramDic = paramObject.toJSON()
    
    JYDNetWorkManager.shareInstance.getDataWithUrl(url: _Main_url + _StoreLocationList_jhtml, paramDic: paramDic!, requestTime: 30, isNeedWaitView: true, isNeedCheckNet: false, success: { (responseStatus, result) in
        let baseResult = BaseModel<Array<Any>>.deserialize(from: result as? NSDictionary)
        successResponse(baseResult!)
    }) { (responseStatus, error) in
        errorResponse(error)
    }
    
}

