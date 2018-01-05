//
//  APPTool.swift
//  FXDProduct
//
//  Created by admin on 2017/7/31.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit

class APPTool: NSObject {
    
    static let shareInstance = APPTool()
    //MARK: 设置View的边框
    func setCornerBorder(view:UIView,borderColor:UIColor) -> Void {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1;
        view.layer.borderColor = borderColor.cgColor
    }
    //MARK: 设置View的圆角
    func setCorner(view:UIView,corner:CGFloat) -> Void {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }
    
    func saveUserDefaul(content:String,key:String) -> Void {
        UserDefaults.standard.set(content, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getContentWithKey(key:String) -> NSString {
        return UserDefaults.standard.value(forKey: key) as! NSString
    }


    
    //MARK: 正则效验手机号
    func isTelNumber(num:String)->Bool {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: num) == true)
            || (regextestcm.evaluate(with: num)  == true)
            || (regextestct.evaluate(with: num) == true)
            || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }else{
            return false
        }
    }
    
    //MARK: 密码
    func isVaildPassword(str:String) -> Bool {
        return str.count > 5
    }
    //MARK: 验证码
    func isVaildVerify(str:String) -> Bool {
        return str.count < 7  &&  str.count > 3
    }
    
    // MARK: 获取app的名字
    func getAPPName() -> String{
        let nameKey = "CFBundleName"
        let appName = Bundle.main.object(forInfoDictionaryKey: nameKey) as? String   //这里也是坑，请不要翻译oc的代码，而是去NSBundle类里面看它的api
        return appName!
    }
    // MARK: 获取app的版本
    func getAPPVersion() -> String{
        let versionKey = "CFBundleShortVersionString"
        let appVersion = Bundle.main.object(forInfoDictionaryKey: versionKey) as? String
        return appVersion!
    }
    
    //MARK: 设备识别
    func getDeviceID() -> String? {
        let uuidStr =  SSKeychain.password(forService: appBundleID, account: appBundleID)
        if (uuidStr != "") && (uuidStr != nil)  {
            return uuidStr!
        }else{
            let str = UUID.init().uuidString
            let isSuccess = SSKeychain.setPassword(str, forService: appBundleID, account: appBundleID)
            if isSuccess{
                return str
            }else{
                print("储存失败")
            }
        }
        return nil
    }
    
    //MARK: 获取ip地址
    func getLocalIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    //MARK:径向渐变
    func drawRadialGradient(context:CGContext) -> Void{
        
        //步骤：
        /*
         一  创建颜色空间
         二  创建渐变
         三  设置裁剪区域
         四  绘制渐变
         五  释放对象
         */
        
        //获取grb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let compents : Array<CGFloat> = [1.0,1.0,1.0,1.0,0.41,0.41,0.41,1.0]
        
        let locations : Array<CGFloat> = [0,1.0]
        
        let gradient = CGGradient.init(colorSpace: colorSpace, colorComponents: compents, locations: locations, count: 2)
        
        context.drawRadialGradient(gradient!, startCenter: CGPoint.init(x: _k_w/2, y: _k_h/2), startRadius: 0 , endCenter:  CGPoint.init(x: _k_w/2, y: _k_h/2), endRadius: _k_h/2 * 1.2, options: CGGradientDrawingOptions(rawValue: 0))
        
    }
    
    //MARK:线性渐变
    func drawLinearGradient(context:CGContext) -> Void{
        //获取grb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let compents : Array<CGFloat> = [1.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0]
        
        let locations : Array<CGFloat> = [0.5,1.0]
        
        let gradient = CGGradient.init(colorSpace: colorSpace, colorComponents: compents, locations: locations, count: 2)
        
        //裁剪区域
        /*
        let rect : Array<CGRect> = [CGRect.init(x: 0, y: 0, width: 100, height: 100),CGRect.init(x: 0, y: 0, width: 100, height: 100),CGRect.init(x: 200, y: 0, width: 100, height: 100),CGRect.init(x: 0, y: 200, width: 100, height: 100),CGRect.init(x: 200, y: 200, width: 100, height: 100),]
        context.clip(to: rect)
        */
        context.drawLinearGradient(gradient!, start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: _k_w, y: _k_h/2), options: CGGradientDrawingOptions.drawsAfterEndLocation)
        
    }
    
     /// 生成纯色图片
     ///
     /// - Parameter color: 颜色
     /// - Returns: 图片
     func imageWithColor(color:UIColor) -> UIImage
    {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func obtainDisplaySize(size:CGFloat) -> CGFloat {
        var fontScale:CGFloat = 1.0;
        if (UI_IS_IPHONE5) {
            fontScale = 1.0;
        }else if (UI_IS_IPONE6){
            fontScale = 1.0;
        }else if (UI_IS_IPHONE6P){
            fontScale = 1.17;
        }else if (UI_IS_IPHONEX){
            fontScale = 1.17;
        }
        return fontScale * size;
    }
}












