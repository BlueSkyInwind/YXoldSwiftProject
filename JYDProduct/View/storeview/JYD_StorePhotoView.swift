//
//  JYD_StorePhotoView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

typealias PhotoImageTap = (_ indexNum:Int) -> Void
class JYD_StorePhotoView: UIView {

    var borderImageView:UIImageView?
    var photoBtn:UIButton?
    var borderImageWidth:CGFloat?
    var photoBtnIndex:Int?
    var photoImageTap:PhotoImageTap?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    convenience init (imageWidth:CGFloat,Image:UIImage,index:Int) {
        self.init(frame: CGRect.zero)
        borderImageWidth = imageWidth - 10
        photoBtnIndex = index
        addPhotoImage(image: Image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func storeImageClick(button:UIButton) {
        if photoImageTap != nil{
            self.photoImageTap!(button.tag)
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

extension JYD_StorePhotoView {
    
    func setUpUI()  {
        
        borderImageView = UIImageView()
        borderImageView?.image = UIImage.init(named: "storePhoto_Icon")
        borderImageView?.isUserInteractionEnabled = true
        self.addSubview(borderImageView!)
        borderImageView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        photoBtn = UIButton.init(type: UIButtonType.custom)
        photoBtn?.addTarget(self, action: #selector(storeImageClick(button:)), for: UIControlEvents.touchUpInside)
        self.addSubview(photoBtn!)
        photoBtn?.snp.makeConstraints({ (make) in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(APPTool.obtainDisplaySize(size: 100))
            make.height.equalTo(APPTool.obtainDisplaySize(size: 100))
        })
    }
    
    func addPhotoImage(image:UIImage)  {
        photoBtn?.setImage(image, for: UIControlState.normal)
        photoBtn?.tag = photoBtnIndex!
        //计算图片尺寸
        let width:CGFloat
        let height:CGFloat
        let scale = image.size.height / image.size.width
        if scale > 1 {
            height = borderImageWidth!
            width = height / scale
        }else{
            width = borderImageWidth!
            height = width * scale
        }
        photoBtn?.snp.updateConstraints({ (make) in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(width)
            make.height.equalTo(height)
        })
    }
}


