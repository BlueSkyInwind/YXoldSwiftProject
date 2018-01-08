//
//  JYD_MapHandler.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

@objc protocol JYD_MapHandlerDelegate: NSObjectProtocol{
   
    func addRepositionButtonClick()
    func addMapEnlargedButtonClick()
    func addMapShrinkButtonClick()
    
}

class JYD_MapHandler: BaseHandler {

    var repositionBtn:UIButton?
    var vc:UIViewController?
    var delegate:JYD_MapHandlerDelegate?
    
    override init() {
        super.init()
        
    }
    
    func addRepositionBtn(_ point:CGPoint)  {
        repositionBtn = UIButton.init(type: UIButtonType.custom)
        repositionBtn?.frame = CGRect.init(x: point.x, y: point.y, width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 38))
        repositionBtn?.setBackgroundImage(UIImage.init(named: "repositionBtn_Icon"), for: UIControlState.normal)
        repositionBtn?.addTarget(self, action: #selector(addRepositionBtnClick), for: UIControlEvents.touchUpInside)
        vc?.view.addSubview(repositionBtn!)
    }
    
    @objc func addRepositionBtnClick() {
        if self.delegate != nil {
            self.delegate?.addRepositionButtonClick()
        }
    }
    
    func addZoomView(_ point:CGPoint)  {
        
        let zoomView = UIView.init(frame: CGRect.init(x: point.x, y: point.y, width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 77)))
        vc?.view.addSubview(zoomView)

        let enlargedBtn = UIButton.init(type: UIButtonType.custom)
        enlargedBtn.frame = CGRect.init(x: 0, y: 0, width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 38))
        enlargedBtn.setBackgroundImage(UIImage.init(named: "mapEnlarge_Icon"), for: UIControlState.normal)
        enlargedBtn.addTarget(self, action: #selector(addEnlargedBtnClick), for: UIControlEvents.touchUpInside)
        zoomView.addSubview(enlargedBtn)
        
        let shrinkBtn = UIButton.init(type: UIButtonType.custom)
        shrinkBtn.frame = CGRect.init(x: 0, y: APPTool.obtainDisplaySize(size: 39), width: APPTool.obtainDisplaySize(size: 35), height: APPTool.obtainDisplaySize(size: 38))
        shrinkBtn.setBackgroundImage(UIImage.init(named: "mapShrink_Icon"), for: UIControlState.normal)
        shrinkBtn.addTarget(self, action: #selector(addShrinkBtnClick), for: UIControlEvents.touchUpInside)
        zoomView.addSubview(shrinkBtn)
        
    }
    
    @objc func addEnlargedBtnClick() {
        if self.delegate != nil {
            self.delegate?.addMapEnlargedButtonClick()
        }
    }
    
    @objc func addShrinkBtnClick() {
        if self.delegate != nil {
            self.delegate?.addMapShrinkButtonClick()
        }
    }
    

}
