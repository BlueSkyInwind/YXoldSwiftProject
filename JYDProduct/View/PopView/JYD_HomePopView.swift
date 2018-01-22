//
//  JYD_HomePopView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/15.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit
import Spring

let ImageEdge = 50

typealias PopImageTapSender = () -> Void
class JYD_HomePopView: UIView {
    
    var popImageView:SpringImageView?
    var closeBtn:UIButton?
    var popImageTap:PopImageTapSender?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(frame: CGRect,imageStr:String) {
        var frame = frame
        frame.size.width = _k_w
        frame.size.height = _k_h
        self.init(frame: frame)
        self.popImageView?.sd_setImage(with: URL.init(string: imageStr), completed: { (image, error, cacheType, imageUrl) in
            if image == nil{
                return
            }
            let height = (image?.size.height)!
            let width =  (image?.size.width)!
            let scale = height / width
            self.popImageView?.snp.remakeConstraints({ (make) in
                make.center.equalTo(self.snp.center)
                make.width.equalTo(_k_w - APPTool.obtainDisplaySize(size: CGFloat(ImageEdge) * 2))
                make.height.equalTo((_k_w-APPTool.obtainDisplaySize(size: CGFloat(ImageEdge) * 2)) * scale)
            })
        })
        self.popImageView?.animate()
    }
    
    @objc func backImageTapClick()  {
        if popImageTap  != nil {
            popImageTap!()
        }
    }
    
    @objc func closePopBtnClick()  {
        closePop()
    }
    
    func closePop()  {
        self.popImageView?.animate()
        self.popImageView?.animateNext {
            self.removeFromSuperview()
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


extension JYD_HomePopView {
    
    func setUpUI()  {
        
        popImageView = SpringImageView()
        popImageView?.isUserInteractionEnabled = true
        popImageView?.animation = Spring.AnimationPreset.Pop.rawValue
        popImageView?.force = 1.0
        popImageView?.damping = 0.5
        popImageView?.velocity = 0
        popImageView?.duration = 1
        popImageView?.curve = Spring.AnimationCurve.EaseInOut.rawValue
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(backImageTapClick))
        popImageView?.addGestureRecognizer(tap)
        self.addSubview(popImageView!)
        popImageView?.snp.makeConstraints({ (make) in
            make.center.equalTo(self.snp.center)
        })
        
        closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn?.setImage(UIImage.init(named: "popWindow_Icon"), for: UIControlState.normal)
        closeBtn?.addTarget(self, action: #selector(closePopBtnClick), for: UIControlEvents.touchUpInside)
        self.addSubview(closeBtn!)
        closeBtn?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.equalTo((closeBtn?.snp.height)!).multipliedBy(1)
            make.bottom.equalTo((popImageView?.snp.top)!).offset(-15)
        })
        
    }
    
    
    
    
    
}
