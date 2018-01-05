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
        
        
    }
    
    
    
    
}



