//
//  CommonExtention.swift
//  fxdProduct
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 dd. All rights reserved.
//

import Foundation
import Spring

//MARK: xib加载
protocol NibLoadProtocol {
    
}

extension NibLoadProtocol where Self : UIView{
    
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}


//MARK: 字符串扩展
extension String {
    
    /// 将十六进制颜色转换为UIColor
    func uiColor() -> UIColor {
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: self[0..<2]).scanHexInt32(&red)
        
        Scanner(string: self[2..<4]).scanHexInt32(&green)
        
        Scanner(string: self[4..<6]).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    /// String使用下标截取字符串
    /// 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex..<endIndex])
        }
    }
}

//MARK: 字体扩展
extension UIFont {
    
   class func obtainDisplayFontSize(fontSize:Float) -> Float {
        var fontScale:Float = 1.0;
        if (UI_IS_IPHONE5) {
            fontScale = 1.0;
        }else if (UI_IS_IPONE6){
            fontScale = 1.0;
        }else if (UI_IS_IPHONE6P){
            fontScale = 1.17;
        }else if (UI_IS_IPHONEX){
            fontScale = 1.17;
        }
        return fontScale * fontSize;
    }
    
   class func FitSystemFontOfSize(fontSize:Float) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(self.obtainDisplayFontSize(fontSize: fontSize)))
    }
    
    class func FitBoldSystemFontOfSize(fontSize:Float) -> UIFont {
        return UIFont.boldSystemFont(ofSize: CGFloat(self.obtainDisplayFontSize(fontSize: fontSize)))
    }
    
   class func FititalicSystemFontOfSize(fontSize:Float) -> UIFont {
        return UIFont.italicSystemFont(ofSize: CGFloat(self.obtainDisplayFontSize(fontSize: fontSize)))
    }
    
   class func FitFontWithName(fontName:String,fontSize:Float) -> UIFont {
        return UIFont.init(name: fontName, size: CGFloat(self.obtainDisplayFontSize(fontSize: fontSize)))!
    }
    
//    func FitSystemFontOfSize(fontSize:Float,weight:Float) -> UIFont {
//        if #available(iOS 8.2, *) {
//            return UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(weight)))
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    
}







