//
//  JYD_SelectPathHeaderView.swift
//  JYDProduct
//
//  Created by sxp on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_SelectPathHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JYD_SelectPathHeaderView {
    
    fileprivate func setupUI(){
        
        let startLabel = UILabel()
        startLabel.text = "从"
        startLabel.font = UIFont.systemFont(ofSize: 15)
        startLabel.textColor = UIColor.white
        self.addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(3)
        }
        
    }
    
    
    override var  frame:(CGRect){
        
        didSet{
            let k_w = UIScreen.main.bounds.size.width
            let newFrame = CGRect(x:0,y:0,width:Int(k_w),height:108)
            super.frame = newFrame
        }
    }
        
}
