//
//  JYD_PaopaoView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_PaopaoView: UIView {
    
    var backGroundImage:UIImageView?
    var contentLabel:UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension JYD_PaopaoView {
    
    func setUpUI()  {
        
        backGroundImage = UIImageView()
        backGroundImage?.image = UIImage.init(named: "Paopao_Icon")
        self.addSubview(backGroundImage!)
        backGroundImage?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        contentLabel = UILabel()
        contentLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 14)
        contentLabel?.textColor =  PaopaoTitleColor
        backGroundImage?.addSubview(contentLabel!)
        contentLabel?.snp.makeConstraints({ (make) in
            make.centerY.equalTo((backGroundImage?.snp.centerY)!)
            make.centerX.equalTo((backGroundImage?.snp.centerX)!).offset(-10)
        })
    }
    
    override var frame:(CGRect){
        didSet{
            if UI_IS_IPHONE5 {
                super.frame = CGRect.init(x: 0, y: 0, width: 137, height: 45)
            }else if UI_IS_IPONE6 {
                super.frame = CGRect.init(x: 0, y: 0, width: 172, height: 56)
            }else{
                super.frame = CGRect.init(x: 0, y: 0, width: 215, height: 70)
            }
        }
    }
    
}



