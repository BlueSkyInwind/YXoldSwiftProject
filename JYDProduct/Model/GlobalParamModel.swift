//
//  GlobalParamModel.swift
//  FXDProduct
//
//  Created by sxp on 2017/8/2.
//  Copyright © 2017年 admin. All rights reserved.
//

import Foundation
import HandyJSON


//MARK:版本检查
struct CheckAPPVersionParam: HandyJSON{
    
    var platform_type_ : String?
    var app_version_ : String?
    
    init() {
    }
}

//MARK:门店列表
struct StoreLocationListParam: HandyJSON{
    
    var lat : Double?
    var lng : Double?
    
    init() {
    }
}

//MARK:门店详情
struct StoreInfoParam: HandyJSON{
    
    var storeId : String?
    init() {
    }
}

//MARK:首页pop
struct HomePopParam: HandyJSON{
    
    var platformType : String?
    init() {
    }
}


