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


/// 获取门店列表
///
/// - Parameters:
///   - userLocation: 用户位置
///   - successResponse: 成功返回
///   - errorResponse: 失败返回
func obtainStoreListLocationInfo(_ userLocation:CLLocationCoordinate2D, successResponse: @escaping ReturnDataValue<BaseModel<Dictionary<String,Any>>>, errorResponse: @escaping ReturnFailure){
    
    var paramObject = StoreLocationListParam()
    paramObject.lng = userLocation.longitude
    paramObject.lat = userLocation.latitude
    let paramDic = paramObject.toJSON()
    
    JYDNetWorkManager.shareInstance.getDataWithUrl(url: _Main_url + _StoreLocationList_jhtml, paramDic: paramDic!, requestTime: 30, isNeedWaitView: true, isNeedCheckNet: false, success: { (responseStatus, result) in
        let baseResult = BaseModel<Dictionary<String,Any>>.deserialize(from: result as? NSDictionary)
        successResponse(baseResult!)
    }) { (responseStatus, error) in
        errorResponse(error)
    }
}

/// 获取门店详情
///
/// - Parameters:
///   - storeId: 门店id
///   - successResponse: 成功返回
///   - errorResponse: 错误返回
func obtainStoreDetailInfo(_ storeId:String, successResponse: @escaping ReturnDataValue<BaseModel<Dictionary<String,Any>>>, errorResponse: @escaping ReturnFailure){
    
    var storeDetailPara = StoreInfoParam()
    storeDetailPara.storeId = storeId
    let paramDic = storeDetailPara.toJSON()
    
    JYDNetWorkManager.shareInstance.getDataWithUrl(url: _Main_url + _StoreInfoDetail_jhtml, paramDic: paramDic!, requestTime: 30, isNeedWaitView: true, isNeedCheckNet: true, success: { (responseStatus, result) in
        let baseResult = BaseModel<Dictionary<String,Any>>.deserialize(from: result as? NSDictionary)
        successResponse(baseResult!)
    }) { (responseStatus, error) in
        errorResponse(error)
    }
}

/// 获取首页弹窗
///
/// - Parameters:
///   - successResponse: 成功返回
///   - errorResponse: 错误返回
func obtainHomePopViewInfo(_ successResponse: @escaping ReturnDataValue<BaseModel<Array<Any>>>, errorResponse: @escaping ReturnFailure){
    
    var popParam = HomePopParam()
    popParam.platformType = PLATFORMType
    let paramDic = popParam.toJSON()
    
    JYDNetWorkManager.shareInstance.getDataWithUrl(url: _Main_url + _HomePop_jhtml, paramDic: paramDic!, requestTime: 30, isNeedWaitView: true, isNeedCheckNet: true, success: { (responseStatus, result) in
        let baseResult = BaseModel<Array<Any>>.deserialize(from: result as? NSDictionary)
        successResponse(baseResult!)
    }) { (responseStatus, error) in
        errorResponse(error)
    }
    
}


