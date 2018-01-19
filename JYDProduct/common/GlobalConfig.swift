//
//   GlobalConfig.swift
//  FXDProduct
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 admin. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import MBProgressHUD
import HandyJSON
import ReactiveCocoa
import ReactiveSwift

//MARK: 全局枚举(验证码)
enum VerifyCode_Type : String{
    
    case CODE_LOGIN = "MSG_LOGIN_"   ///登陆验证码
    case CODE_REG = "MSG_REG_"          ///注册验证码
    case CODE_FINDPASS = "MSG_FIND_PASSWORD_"  ///密码找回验证码
    case CODE_CHANGEPASS = "MSG_UPDATE_PASSWORD_"  ///修改密码验证码
    case CODE_CHANGEDEVID = "MSG_CHANGE_DEVICE_"   ///设备号更改
    case CODE_BANKMOBILE = "MSG_CHANGE_DEBIT_"   ///银行预留手机验证码(银行卡修改)
    case CODE_DRAW = "MSG_DRAW_" ///提款
    case CODE_ADDCARD = "MSG_BANKCARD_AUDIT_"   //新增卡
    
}

//MARK: 项目配置信息
//服务器识别平台号
let CHANNEL = "1"
let PLATFORMType = "13"

let Fxd_JUID = "juid"
let Fxd_Token = "token"
//登录状态
let kLoginFlag = "loginFlag"
//邀请码
let kInvitationCode = "invitation_code"
//用户id
let Fxd_AccountId = "AccountId"
//用户名
let Fxd_userName = "userName"

let BMK_AK = "BzL71nwZdHQ3EUIzPHmxa28HwFAfzCoM"

let Umeng_Key = "5a616260f43e4828e5000041"

// app 商店地址
let appStoreAdress = ""

// MARK: 设备信息获取
let  _k_w = UIScreen.main.bounds.size.width
let  _k_h = UIScreen.main.bounds.size.height

let deviceName = UIDevice.current.name

let systemName = UIDevice.current.systemName

let deviceUUID = UIDevice.current.identifierForVendor?.uuidString

let UI_IS_IPHONE = (UIDevice.current.userInterfaceIdiom == .phone)
let UI_IS_IPHONE5 = (UI_IS_IPHONE && _k_h == 568.0)
let UI_IS_IPONE6 = (UI_IS_IPHONE && _k_h == 667.0)
let UI_IS_IPHONE6P = (UI_IS_IPHONE && _k_h == 736.0)
let UI_IS_IPHONE4 = (UI_IS_IPHONE && _k_h == 480.0)
let UI_IS_IPHONEX = (UI_IS_IPHONE && _k_h == 812.0)

let appBundleID = "com.hfsj.jyd"

let KCharacterNumber = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

//MARK:为加载的html内容加上格式
let WebView_Style = "<header><meta name='viewport' content='width=device-width, initial-scale=0.8, maximum-scale=0.8, minimum-scale=0.8, user-scalable=no'></header>"

//MARK:获取nav的高度
func obtainBarHeight_New(vc:UIViewController) -> Int{
    return Int(UIApplication.shared.statusBarFrame.size.height + (vc.navigationController?.navigationBar.frame.size.height)!)
}

//MARK:获取App的名字
let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

//MARK:格式化输出   这里 T 表示不指定 message参数类型
func DPrint<T>(message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        // 需要在 buildSetting 中配置 swift flags的参数为:-D DEBUG, DEBUG可以自定义, 一般用 DEBUG
        // 搜 swift flags-->other swift flags-->DEBUG-->点+号-->输入上面的配置参数
        // 1.对文件进行处理
        let fileName = (file as NSString).lastPathComponent
        // 2.打印内容
        print("[\(fileName)][\(funcName)](\(lineNum)):\(message)")
    #endif
}






















