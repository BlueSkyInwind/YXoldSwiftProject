//
//  JYD_homeBottomView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

typealias DisplayPathTapClick = () -> Void
class JYD_homeBottomView: UIView {
    
    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var adressLabel:UILabel?
    var pathView:UIView?
    var pathIcon:UIImageView?
    var distanceLabel:UILabel?
    var displayPathTapClick:DisplayPathTapClick?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(displayPathClick))
        pathView?.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func  displayPathClick() {
        if displayPathTapClick != nil {
            displayPathTapClick!()
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
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 15)
        titleLabel?.textColor = homeBottomTitleColor
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo(self.snp.top).offset(APPTool.obtainDisplaySize(size: 15))
        })
        
        timeLabel = UILabel()
        timeLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 13)
        timeLabel?.textColor = homeBottomContentColor
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo((titleLabel?.snp.top)!).offset(APPTool.obtainDisplaySize(size: 10))
        })
        
        adressLabel = UILabel()
        adressLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 13)
        adressLabel?.textColor = homeBottomContentColor
        self.addSubview(adressLabel!)
        adressLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo((timeLabel?.snp.top)!).offset(APPTool.obtainDisplaySize(size: 10))
        })
        
        pathView = UIView()
        pathView?.backgroundColor = appMainBg
        self.addSubview(pathView!)
        pathView?.snp.makeConstraints({ (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(self.snp.height)
        })
        
        pathIcon = UIImageView()
        pathIcon?.image = UIImage.init(named: "path_Icon")
        pathIcon?.isUserInteractionEnabled  = true
        pathView?.addSubview(pathIcon!)
        pathIcon?.snp.makeConstraints({ (make) in
            make.centerX.equalTo((pathView?.snp.centerX)!)
            make.centerY.equalTo((pathIcon?.snp.centerY)!).offset(-10)
        })
        
        distanceLabel = UILabel()
        distanceLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 12)
        distanceLabel?.textColor = UIColor.white
        self.addSubview(distanceLabel!)
        distanceLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo((pathView?.snp.centerX)!)
            make.centerY.equalTo((pathIcon?.snp.centerY)!).offset(10)
        })

    }
    
    
}


