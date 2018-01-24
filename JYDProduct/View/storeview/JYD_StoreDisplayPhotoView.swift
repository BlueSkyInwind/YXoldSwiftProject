//
//  JYD_StoreDisplayPhotoView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit
import SDWebImage

typealias MakingCallStoreTel = () -> Void
typealias StoreImageClickIndex = (_ index:Int,_ photos:[UIImage]) -> Void
class JYD_StoreDisplayPhotoView: UIView {
    
    var titleLabel:UILabel?
    var imageBackView:UIView?
    var telBackView:UIView?
    var telLabel:UILabel?
    var telIconView:UIImageView?

    var photos:[UIImage]? = [UIImage.init(named: "placeHolder_Icon")!,UIImage.init(named: "placeHolder_Icon")!,UIImage.init(named: "placeHolder_Icon")!]
    var photoStrs:[String]?
    var clickIndex:StoreImageClickIndex?
    var imageViewArr:[UIButton] = []
    
    var callStoreTel:MakingCallStoreTel?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUpUI()
    }
    
    convenience init(frame: CGRect,images:[String],telStr:String) {
        self.init(frame: frame)
        self.telLabel?.text = telStr
        photoStrs = images
        addStorePhoto()
    }
    
    @objc func storeImageClick(button:UIButton) {
        let count = photoStrs?.count
        let results = Array(photos![0..<count!])
        if clickIndex != nil {
            self.clickIndex!(button.tag - 1000 + 1,results)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func userTelTapSender (){
        if callStoreTel != nil{
            callStoreTel!()
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
        
        telBackView = UIView()
        let telTap  = UITapGestureRecognizer.init(target: self, action: #selector(userTelTapSender))
        telBackView?.addGestureRecognizer(telTap)
        self.addSubview(telBackView!)
        telBackView?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-15)
            make.top.equalTo(self.snp.top).offset(15)
            make.width.equalTo(200)
            make.height.equalTo(20)
        })
        
        telIconView = UIImageView()
        telIconView?.image = UIImage.init(named: "store_Tel_Icon")
        telIconView?.isUserInteractionEnabled = true
        telBackView?.addSubview(telIconView!)
        telIconView?.snp.makeConstraints({ (make) in
            make.right.equalTo((telBackView?.snp.right)!).offset(0)
            make.width.height.equalTo((telBackView?.snp.height)!)
            make.bottom.equalTo(0)
        })
        
        telLabel = UILabel()
        telLabel?.textColor = StoreTelBack_Color
        telLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 12)
        telLabel?.isUserInteractionEnabled = true
        telIconView?.addSubview(telLabel!)
        telLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo((telIconView?.snp.left)!).offset(-8)
            make.bottom.equalTo(0)
        })
        
        imageBackView = UIView()
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
//        SDWebImageDownloader.shared().setValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
        imageBtn.sd_setImage(with: URL.init(string: urlStr), for: UIControlState.normal, placeholderImage: UIImage.init(named: "placeHolder_Icon"), options: SDWebImageOptions.refreshCached) {[weak self] (image, error, cacheType, imageURL) in
            if image == nil {
                return
            }
            let index = self?.photoStrs?.index(of: (imageURL?.absoluteString)!)
            self?.photos?.insert(image!, at: index!)
            self?.photos?.remove(at: index! + 1)
        }
    }
}



