//
//  APPUrl.swift
//  FXDProduct
//
//  Created by admin on 2017/7/31.
//  Copyright © 2017年 admin. All rights reserved.
//

import Foundation

// MARK: 项目地址
#if DEBUG

//let _Main_url = "http://h5.test.fxds/apigw/client/jyd/"
let _Main_url = "http://h5.dev.fxds/apigw/client/jyd/"

#else
    
//生产链接
let _Main_url = "https://h5.faxindai.com/apigw/client/jyd/"

#endif

//MARK: 项目url

//附近门店列表
let _StoreLocationList_jhtml = "cooperationStore/list"

//附近门店详情
let _StoreInfoDetail_jhtml = "cooperationStore/get"

//首页活动弹窗
let _HomePop_jhtml = "pop/list"


