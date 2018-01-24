//
//  JYD_HomeHeaderView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

typealias BackGroundViewTap = () -> Void
class JYD_HomeHeaderView: UIView {
    
    var backGroundImage:UIImageView?
    var titleImage:UIImageView?
    var titleLabel:UILabel?
    var rightIcon:UIImageView?
    var backGroundViewTap:BackGroundViewTap?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backGroundViewTapClick()  {
        if backGroundViewTap != nil {
            backGroundViewTap!()
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

extension JYD_HomeHeaderView {
    
    func setUpUI()  {
        
        backGroundImage = UIImageView()
        backGroundImage?.image = UIImage.init(named: "headerBackGround_Icon")
        backGroundImage?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(backGroundViewTapClick))
        backGroundImage?.addGestureRecognizer(tap)
        self.addSubview(backGroundImage!)
        backGroundImage?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        titleImage = UIImageView()
        titleImage?.image = UIImage.init(named: "homeStore_Icon")
        titleImage?.isUserInteractionEnabled = true
        backGroundImage?.addSubview(titleImage!)
        titleImage?.snp.makeConstraints({ (make) in
            make.centerY.equalTo((backGroundImage?.snp.centerY)!).offset(-2)
            make.left.equalTo((backGroundImage?.snp.left)!).offset(APPTool.obtainDisplaySize(size: 15))
        })
        
        rightIcon = UIImageView()
        rightIcon?.image = UIImage.init(named: "goStoreList_Icon")
        rightIcon?.isUserInteractionEnabled = true
        backGroundImage?.addSubview(rightIcon!)
        rightIcon?.snp.makeConstraints({ (make) in
            make.centerY.equalTo((backGroundImage?.snp.centerY)!).offset(-2)
            make.right.equalTo((backGroundImage?.snp.right)!).offset(-(APPTool.obtainDisplaySize(size: 15)))
        })
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 17)
        titleLabel?.textColor =  homeHeaderTitleColor
        titleLabel?.isUserInteractionEnabled = true
//        titleLabel?.text = "线下借款门店，列表查看"
        backGroundImage?.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.center.equalTo((backGroundImage?.snp.center)!)
        })
    }

}



