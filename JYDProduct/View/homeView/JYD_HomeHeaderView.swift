//
//  JYD_HomeHeaderView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

typealias RightIconButtonClick = () -> Void
class JYD_HomeHeaderView: UIView {
    
    var backGroundImage:UIImageView?
    var titleImage:UIImageView?
    var titleLabel:UILabel?
    var rightIconBtn:UIButton?
    var rightIconButtonClick:RightIconButtonClick?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func rightIconBtnClick()  {
        if rightIconButtonClick != nil {
            rightIconButtonClick!()
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
        
        rightIconBtn = UIButton.init(type: UIButtonType.custom)
        rightIconBtn?.setImage(UIImage.init(named: "goStoreList_Icon"), for: UIControlState.normal)
        rightIconBtn?.addTarget(self, action: #selector(rightIconBtnClick), for: UIControlEvents.touchUpInside)
        backGroundImage?.addSubview(rightIconBtn!)
        rightIconBtn?.snp.makeConstraints({ (make) in
            make.centerY.equalTo((backGroundImage?.snp.centerY)!).offset(-2)
            make.right.equalTo((backGroundImage?.snp.right)!).offset(-(APPTool.obtainDisplaySize(size: 15)))
        })
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 17)
        titleLabel?.textColor =  homeHeaderTitleColor
//        titleLabel?.text = "线下借款门店，列表查看"
        backGroundImage?.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.center.equalTo((backGroundImage?.snp.center)!)
        })

    }

}



