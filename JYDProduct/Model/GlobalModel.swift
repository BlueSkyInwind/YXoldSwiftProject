//
//  GlobalModel.swift
//  FXDProduct
//
//  Created by admin on 2017/8/2.
//  Copyright © 2017年 admin. All rights reserved.
//

import Foundation
import HandyJSON


struct BaseModel<T>:HandyJSON{
    
    var errCode : String?
    var errMsg : String?
    var friendErrMsg : String?
    var data : T?
    
}
struct GroundInfoResult:HandyJSON{
    
    var distance: String?
    var storeList: Array<StoreListResult>?

}

struct StoreListResult:HandyJSON{
    
    var areaName: String?
    var businessHours: String?
    var cityName: String?
    var cooperationStatus: String?
    var distance: String?
    var endLoanTime: String?
    var storeId: String?
    var mapMarkLatitude: String?
    var mapMarkLongitude: String?
    var picList: String?
    var provinceName: String?
    var startLoanTime: String?
    var storeAddress: String?
    var storeName: String?
    var storePhone: String?
    
}

struct StoreDetailResult:HandyJSON{
    
    var areaName: String?
    var businessHours: String?
    var cityName: String?
    var cooperationStatus: String?
    var distance: String?
    var endLoanTime: String?
    var storeId: String?
    var mapMarkLatitude: String?
    var mapMarkLongitude: String?
    var picList: Array<String>?
    var provinceName: String?
    var startLoanTime: String?
    var storeAddress: String?
    var storeName: String?
    var storePhone: String?
    var loanAmount: String?

}

struct HomePopResult:HandyJSON{
    
    var image: String?
    var isValid: String?
    var toUrl: String?
    
}








