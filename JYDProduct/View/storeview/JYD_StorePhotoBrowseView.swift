//
//  JYD_StorePhotoBrowseView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

let  imageSpace:CGFloat = 5
typealias ViewBackTapClick = () -> Void
class JYD_StorePhotoBrowseView: UIView,UIScrollViewDelegate {
    
    var leftBtn:UIButton?
    var rightBtn:UIButton?
    var browseScrollView:UIScrollView?
    var images:[UIImage]?
    var imageViewArr:[UIImageView] = []
    var selectDisplayImage:Int = 1
    var titleLabel:UILabel?
    var viewBackTap:ViewBackTapClick?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewTapClick))
        self.addGestureRecognizer(tap)
    }
    
    @objc func viewTapClick() {
        if viewBackTap != nil {
            viewBackTap!()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect,displayImages:[UIImage],selectIndex:Int) {
        self.init(frame: frame)
        images = displayImages
        selectDisplayImage = selectIndex - 1
        setUpUI()
    }
    
    @objc func lastPhotoClick()  {
        
        self.selectDisplayImage -= 1
        self.selectDisplayImage =  self.selectDisplayImage  > 0 ? self.selectDisplayImage : 0
        browseScrollView?.setContentOffset(CGPoint.init(x:(browseScrollView?.bounds.size.width)!  * CGFloat(self.selectDisplayImage) , y: 0), animated: true)
        titleLabel?.text = "\(self.selectDisplayImage + 1)" + "/" + "\(images?.count ?? 1)"

    }

    @objc func nextPhotoClick()  {
        
        self.selectDisplayImage += 1
        self.selectDisplayImage =  self.selectDisplayImage  > (images?.count)! - 1 ? (images?.count)! - 1 : self.selectDisplayImage
        browseScrollView?.setContentOffset(CGPoint.init(x:(browseScrollView?.bounds.size.width)!  * CGFloat(self.selectDisplayImage) , y: 0), animated: true)
        titleLabel?.text = "\(self.selectDisplayImage + 1)" + "/" + "\(images?.count ?? 1)"
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int((browseScrollView?.bounds.size.width)!)
        self.selectDisplayImage = Int(index)
        titleLabel?.text = "\(self.selectDisplayImage + 1)" + "/" + "\(images?.count ?? 1)"
    }
}

extension JYD_StorePhotoBrowseView {
    
    func setUpUI()  {
        
        titleLabel = UILabel()
        titleLabel?.textColor = UIColor.white
        titleLabel?.text = "\(self.selectDisplayImage + 1)" + "/" + "\(images?.count ?? 1)"
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top).offset(60)
            make.centerX.equalTo(self.snp.centerX)
        })
        
        leftBtn = UIButton.init(type: UIButtonType.custom)
        leftBtn?.setImage(UIImage.init(named: "leftButton_Icon"), for: UIControlState.normal)
        leftBtn?.addTarget(self, action: #selector(lastPhotoClick), for: UIControlEvents.touchUpInside)
        self.addSubview(leftBtn!)
        leftBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(5)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(APPTool.obtainDisplaySize(size: 20))
            make.height.equalTo(APPTool.obtainDisplaySize(size: 35))
        })
        
        rightBtn = UIButton.init(type: UIButtonType.custom)
        rightBtn?.setImage(UIImage.init(named: "rightButton_Icon"), for: UIControlState.normal)
        rightBtn?.addTarget(self, action: #selector(nextPhotoClick), for: UIControlEvents.touchUpInside)
        self.addSubview(rightBtn!)
        rightBtn?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-5)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(APPTool.obtainDisplaySize(size: 20))
            make.height.equalTo(APPTool.obtainDisplaySize(size: 35))
        })
        
        browseScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width:_k_w - APPTool.obtainDisplaySize(size: 80), height:  _k_h - 200))
        browseScrollView?.center = self.center
        browseScrollView?.backgroundColor = UIColor.black
        browseScrollView?.isPagingEnabled = true
        browseScrollView?.showsVerticalScrollIndicator = false
        browseScrollView?.showsHorizontalScrollIndicator = false
        browseScrollView?.delegate = self
        self.addSubview(browseScrollView!)
        
        let imageWidth = (browseScrollView?.bounds.size.width)! + imageSpace * 2.0
        
        browseScrollView?.frame = CGRect.init(x: -imageWidth, y: 0, width: imageWidth, height: _k_h - 200)
        browseScrollView?.center = self.center
        browseScrollView?.contentSize = CGSize.init(width: imageWidth * CGFloat((images?.count)!), height: 0)
        browseScrollView?.contentOffset = CGPoint.init(x:imageWidth * CGFloat(self.selectDisplayImage) , y: 0)
        
        let count = images?.count
        for index in 0..<count! {
            let image = images![index]
            let imageX = ((browseScrollView?.bounds.size.width)! / 2) + imageWidth  * CGFloat(index)
            let imageView = UIImageView()
            imageView.frame = CGRect.init(x: 0 , y: 0, width: imageWidth, height: imageWidth * image.size.height / image.size.width).insetBy(dx: imageSpace, dy: 0)
            imageView.center = CGPoint.init(x:imageX , y:((browseScrollView?.bounds.size.height)! / 2))
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.image = image
            browseScrollView?.addSubview(imageView)
            imageViewArr.append(imageView)
        }
    }
}











