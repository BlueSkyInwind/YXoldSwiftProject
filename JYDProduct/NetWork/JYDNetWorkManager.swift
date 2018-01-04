//
//  JYDNetWorkManager.swift
//  FXDProduct
//
//  Created by admin on 2017/7/31.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


public enum httpResponseStatus : Int{
    
    ///返回数据正确
  case  Enum_SUCCESS = 0
    ///返回数据出错
  case   Enum_FAIL = 1
    ///连接不上服务器
  case  Enum_NOTCONNECTED = 2
    ///超时连接
  case  Enum_CONNECTEDTIMEOUT = 3
}

typealias SuccessResponse = (_ responseStatus:httpResponseStatus, _ responseObject:AnyObject) -> Void
typealias FailureResponse = (_ responseStatus:httpResponseStatus, _ responseError:Error) -> Void

class JYDNetWorkManager: NSObject {
    
    static let shareInstance = JYDNetWorkManager()
    
    var manager : SessionManager?
    
    //MARK: POST网络请求
    func postDataWithUrl(url:String,
                         paramDic:Dictionary<String , Any> ,
                         requestTime:TimeInterval,
                         isNeedWaitView:Bool,
                         isNeedCheckNet:Bool,
                         success:@escaping SuccessResponse,
                         failure: @escaping FailureResponse) ->  Void{
        
        let method = "POST"
        self.obtainDataWithUrl(url: url, method: method, paramDic: paramDic ,requestTime:requestTime, isNeedWaitView:isNeedWaitView,isNeedCheckNet:isNeedCheckNet, success: success, failure: failure)
    }
    // MARK: GET网络请求
    func getDataWithUrl(url:String,
                        paramDic:Dictionary<String , Any> ,
                        requestTime:TimeInterval,
                        isNeedWaitView:Bool,
                        isNeedCheckNet:Bool,
                        success:@escaping SuccessResponse,
                        failure: @escaping FailureResponse) ->  Void{
        let method = "GET"
        self.obtainDataWithUrl(url: url, method: method, paramDic: paramDic,requestTime:requestTime, isNeedWaitView:isNeedWaitView, isNeedCheckNet:isNeedCheckNet,success: success, failure: failure)
    }
    
    // MARK: DELETE网络请求
    func deleteDataWithUrl(url:String,
                           paramDic:Dictionary<String , Any> ,
                           requestTime:TimeInterval,
                           isNeedWaitView:Bool,
                           isNeedCheckNet:Bool,
                           success:@escaping SuccessResponse,
                           failure: @escaping FailureResponse) ->  Void{
        let method = "DELETE"
        self.obtainDataWithUrl(url: url, method: method, paramDic: paramDic,requestTime:requestTime, isNeedWaitView:isNeedWaitView,isNeedCheckNet:isNeedCheckNet,success: success, failure: failure)
    }
    
    
    // MARK: 底层网络请求
    func obtainDataWithUrl(url:String,
                           method:String,
                           paramDic:Dictionary<String , Any>,
                           requestTime:TimeInterval,
                           isNeedWaitView:Bool,
                           isNeedCheckNet:Bool,
                           success:@escaping SuccessResponse,
                           failure: @escaping FailureResponse) -> Void {
        //请求前状态检查
        guard checkInfoResult(isNeed:isNeedCheckNet) else{
            return
        }
        //加载动画视图
        var requestWaitView  = MBProgressHUD()
        if isNeedWaitView {
            requestWaitView  = self.loadingHUD()
            requestWaitView.show(animated: true)
        }
        //请求参数加密处理
//        let requestParam = self.requestParamDeal(paramDic: paramDic)
        let requestParam = paramDic

        //请求方法
        let urlMethod = HTTPMethod.init(rawValue: method)
        //URL
        let requestUrl = URL.init(string: url)
        //超时设置
        manager = Alamofire.SessionManager.default
        manager?.session.configuration.timeoutIntervalForRequest = requestTime
        
        //请求头
        var requestHeader:HTTPHeaders? = nil
        if (APPUtilityInfo.shareInstance.userInfo.juid != nil) {
             requestHeader = ["\(APPUtilityInfo.shareInstance.userInfo.tokenStr ?? "")":"\(APPUtilityInfo.shareInstance.userInfo.tokenStr ?? "")","juid":"\(APPUtilityInfo.shareInstance.userInfo.juid ?? "")"];
        }
        
        //发起请求回调
        manager?.request(requestUrl!, method: urlMethod!, parameters: requestParam, encoding: JSONEncoding.default,headers:requestHeader).responseJSON { (response) in
            //发起请求的URL
            print("\(String(describing: response.response?.url))")
            //失败返回
            if (response.error != nil) {
                MBPAlertView.shareInstance.showTextOnly(message: requestFailPrompt, view: UIApplication.shared.keyWindow!)
                failure(.Enum_FAIL,response.error!)
                requestWaitView.removeFromSuperview()
            }
            //成功返回
            if (response.value != nil) {
                print(response.value)
                success(.Enum_SUCCESS,response.result.value as AnyObject)
                requestWaitView.removeFromSuperview()
            }
        }
    }
    
    // MARK: 参数加密处理
    func requestParamDeal(paramDic:Dictionary<String, Any>) -> Dictionary<String, Any> {
        
         var jsonString :String? = nil
         var resultParam : Dictionary<String, Any>?
         let jsonData = try? JSONSerialization.data(withJSONObject: paramDic, options: .prettyPrinted)
        
        guard (jsonData != nil) else {
            return resultParam!
        }

        jsonString = String.init(data: jsonData!, encoding: String.Encoding.utf8)
        let encryptStr = DES3Util.encrypt(jsonString)!
        resultParam = ["record":encryptStr]
        return resultParam!
    }
    
    //MARK: 网络状况 和 app强制更新判断
    func checkInfoResult(isNeed:Bool) -> Bool {
        
        var result = true
        
        if !APPUtilityInfo.shareInstance.networkState && isNeed {
            MBPAlertView.shareInstance.showTextOnly(message: networkDisconnectionPrompt, view: UIApplication.shared.keyWindow!)
            result = false
        }
        
        if APPUtilityInfo.shareInstance.isAppUpdate {
//            HHAlertViewCust.sharedHHAlertView().showHHalertView(.fadeIn, leaveMode: .fadeOut, disPlay: .warning, title: nil, detail: versionUpdatePrompt, cencelBtn: nil, otherBtn: ["确定"], onview: UIApplication.shared.keyWindow, compleBlock: { (index) in
//                if index == 1 {
//                    result = false
//                }
//            })
        }
        return result
    }
    
    // MARK: 网络请求加载动画
    func loadingHUD() -> MBProgressHUD {
        
        let Arr = ["load4","load3","load2","load1"]
        let imageV = UIImageView.init(frame: CGRect(x:0,y:0,width:70,height:70))
        var imgArr = [UIImage]()
        for imgIndex in 0...Arr.count - 1 {
            imgArr.append(UIImage.init(named: Arr[imgIndex])!)
        }
        imageV.animationImages = imgArr
        imageV.animationDuration = TimeInterval(imgArr.count / 3)
        imageV.animationRepeatCount = 0
        imageV.startAnimating()
        let waitView = MBProgressHUD.init(view: UIApplication.shared.keyWindow!)
        waitView.mode = MBProgressHUDMode.customView
        waitView.customView = imageV
        waitView.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        UIApplication.shared.keyWindow?.addSubview(waitView)
        return waitView
    }
    
}
