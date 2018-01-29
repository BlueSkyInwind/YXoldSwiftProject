//
//  JYD_homeBottomView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

typealias DisplayPathTapClick = () -> Void
typealias StoreDetailTapClick = () -> Void

class JYD_homeBottomView: UIView {
    
    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var adressLabel:UILabel?
    var pathView:UIView?
    var pathIcon:UIImageView?
    var distanceLabel:UILabel?
    var displayPathTapClick:DisplayPathTapClick?
    var storeDetailTapClick:StoreDetailTapClick?
    var bottonViewHeight:CGFloat = 90

    var VC:UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUpUI()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(displayPathClick))
        pathView?.addGestureRecognizer(tap)
        let tapTwo = UITapGestureRecognizer.init(target: self, action: #selector(storeDetailClick))
        self.addGestureRecognizer(tapTwo)
    }
    
    convenience init (vc:UIViewController,titleStr:String,timeStr:String,addressStr:String,distanceStr:String) {
        self.init(frame: CGRect.init(x: 0, y: _k_h, width: _k_w, height: APPTool.obtainDisplaySize(size: 100)))
        VC = vc
        setContent(titleStr: titleStr, timeStr: timeStr, addressStr: addressStr, distanceStr: distanceStr)
    }
    
    func setContent(titleStr:String,timeStr:String,addressStr:String,distanceStr:String)  {
        self.titleLabel?.text = titleStr
        self.timeLabel?.text = timeStr
        self.adressLabel?.text = addressStr
        self.distanceLabel?.text = distanceStr
        
        let addressHeight = APPTool.shareInstance.obtainLabelHeight(address: addressStr as NSString, width: _k_w - self.bounds.size.height)
        bottonViewHeight = 90 + addressHeight
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func  displayPathClick() {
        if displayPathTapClick != nil {
            displayPathTapClick!()
        }
    }
    @objc func  storeDetailClick() {
        if storeDetailTapClick != nil {
            storeDetailTapClick!()
        }
    }
    
    //MARK: 弹窗动画
    @objc func show()  {
        VC?.view.addSubview(self)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.frame = CGRect.init(x: 0, y: _k_h - APPTool.obtainDisplaySize(size: self.bottonViewHeight), width: _k_w, height: APPTool.obtainDisplaySize(size: self.bottonViewHeight))
        }) { (complication) in
        }
    }
    
    @objc  func dismiss()  {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.frame = CGRect.init(x: 0, y: _k_h, width: _k_w, height: APPTool.obtainDisplaySize(size: self.bottonViewHeight))
        }) { (complication) in
            self.removeFromSuperview()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension JYD_homeBottomView {
    
    func setUpUI()  {
        
        let lineView = UIView()
        lineView.backgroundColor = lineView_Color
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(1)
        }
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.FitBoldSystemFontOfSize(fontSize: 14)
        titleLabel?.textColor = homeHeaderTitleColor
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo(self.snp.top).offset(APPTool.obtainDisplaySize(size: 15))
        })
        
        pathView = UIView()
        pathView?.backgroundColor = appMainBg
        self.addSubview(pathView!)
        pathView?.snp.makeConstraints({ (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(APPTool.obtainDisplaySize(size: 90))
        })
        
        timeLabel = UILabel()
        timeLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 13)
        timeLabel?.textColor = SelectPathTime_Color
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo((titleLabel?.snp.bottom)!).offset(APPTool.obtainDisplaySize(size: 8))
        })
        
        adressLabel = UILabel()
        adressLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 13)
        adressLabel?.textColor = SelectPathTime_Color
        adressLabel?.numberOfLines = 0
        self.addSubview(adressLabel!)
        adressLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo((timeLabel?.snp.bottom)!).offset(APPTool.obtainDisplaySize(size: 8))
            make.right.equalTo((pathView?.snp.left)!).offset(-5)
        })
    
        pathIcon = UIImageView()
        pathIcon?.image = UIImage.init(named: "path_Icon")
        pathIcon?.isUserInteractionEnabled  = true
        pathView?.addSubview(pathIcon!)
        pathIcon?.snp.makeConstraints({ (make) in
            make.centerX.equalTo((pathView?.snp.centerX)!)
            make.centerY.equalTo((pathView?.snp.centerY)!).offset(-10)
        })
        
        distanceLabel = UILabel()
        distanceLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 12)
        distanceLabel?.textColor = UIColor.white
        pathView?.addSubview(distanceLabel!)
        distanceLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo((pathView?.snp.centerX)!)
            make.centerY.equalTo((pathView?.snp.centerY)!).offset(10)
        })
    }
}


