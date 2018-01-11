//
//  JYD_StoreDisplayPhotoView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

typealias StoreImageClickIndex = (_ index:Int) -> Void
class JYD_StoreDisplayPhotoView: UIView {
    
    var titleLabel:UILabel?
    var imageBackView:UIView?
    var photos:[String]?
    var clickIndex:StoreImageClickIndex?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    convenience init(frame: CGRect,images:[String]) {
        self.init(frame: frame)
        photos = images
        addStorePhoto()
    }
    
    @objc func storeImageClick(button:UIButton) {
        if clickIndex != nil {
            self.clickIndex!(button.tag - 1000)
        }
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

extension JYD_StoreDisplayPhotoView {
    
    func setUpUI()  {
        
        titleLabel = UILabel()
        titleLabel?.text = storeDetailImageTitle
        titleLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 15)
        titleLabel?.textColor = StoreDetailImageTitle_Color
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.top.equalTo(self.snp.top).offset(15)
        })
        
        imageBackView = UIView()
        imageBackView?.backgroundColor = UIColor.white
        imageBackView?.isUserInteractionEnabled = true
        self.addSubview(imageBackView!)
        imageBackView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo((titleLabel?.snp.bottom)!)
        })
    }
    
    func addStorePhoto()  {
        let imageWidth = APPTool.obtainDisplaySize(size: 90)
        for imageName in photos! {
            let index = CGFloat((photos?.index(of: imageName))!)
            let imageLeft = (_k_w / 3 - imageWidth) / 2  +  (_k_w / 3 * index)
            let imageBtn = UIButton.init(type: UIButtonType.custom)
            imageBtn.tag = Int(1000 + index)
            imageBtn.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
            imageBtn.addTarget(self, action: #selector(storeImageClick(button:)), for: UIControlEvents.touchUpInside)
            imageBackView?.addSubview(imageBtn)
            imageBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo((imageBackView?.snp.centerY)!)
                make.left.equalTo(imageLeft)
                make.height.width.equalTo(imageWidth)
            })
        }
    }
}



