//
//  JYD_StoreDisplayPhotoView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit
import SDWebImage

typealias StoreImageClickIndex = (_ index:Int,_ photos:[UIImage]) -> Void
class JYD_StoreDisplayPhotoView: UIView {
    
    var titleLabel:UILabel?
    var imageBackView:UIView?
    var photos:[UIImage]? = []
    var photoStrs:[String]?
    var clickIndex:StoreImageClickIndex?
    var imageViewArr:[UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    convenience init(frame: CGRect,images:[String]) {
        self.init(frame: frame)
        photoStrs = images
        addStorePhoto()
    }
    
    @objc func storeImageClick(button:UIButton) {
        if clickIndex != nil {
            self.clickIndex!(button.tag - 1000 + 1,photos!)
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
        let count = photoStrs?.count
        for index in 0..<count!  {
            let imageStr = photoStrs![index]
            let imageLeft = (_k_w / 3 - imageWidth) / 2  +  (_k_w / 3 * CGFloat(index))
            let imageBtn = UIButton.init(type: UIButtonType.custom)
            imageBtn.tag = Int(1000 + index)
            loadSotreImage(imageStr, imageBtn: imageBtn)
            imageBtn.addTarget(self, action: #selector(storeImageClick(button:)), for: UIControlEvents.touchUpInside)
            imageBackView?.addSubview(imageBtn)
            imageViewArr.append(imageBtn)
            imageBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo((imageBackView?.snp.centerY)!)
                make.left.equalTo(imageLeft)
                make.height.width.equalTo(imageWidth)
            })
        }
    }
    
    func loadSotreImage(_ urlStr:String,imageBtn:UIButton)  {
        imageBtn.sd_setImage(with: URL.init(string: urlStr), for: UIControlState.normal, placeholderImage: UIImage.init(named: "placeHolder_Icon"), options: SDWebImageOptions.progressiveDownload) {[weak self] (image, error, cacheType, imageURL) in
            self?.photos?.append(image!)
        }
    }
}



