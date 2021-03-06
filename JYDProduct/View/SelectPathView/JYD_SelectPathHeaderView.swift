//
//  JYD_SelectPathHeaderView.swift
//  JYDProduct
//
//  Created by sxp on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

@objc protocol JYD_SelectPathHeaderDelegate : NSObjectProtocol {
    
    //交换起始位置
    func changeLocationBtn(startLocation : String , endLocation : String)
    //交通工具路线
    func showRoute(tag : Int)
    //返回按钮
    func back()
    
}
class JYD_SelectPathHeaderView: UIView {

    @objc weak var delegate : JYD_SelectPathHeaderDelegate?
    //开始位置
    var startLocationLabel : UILabel?
    //终点位置
    var endLocationLabel : UILabel?
    //按钮下的下划线
    var lineImageView : UIImageView?
    
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
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named:"appBackBtn_whiteIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(30)
            make.width.equalTo(10)
            make.height.equalTo(18)
        }
        
        let backBtn = UIButton()
        backBtn.addTarget(self, action:#selector(back) , for: .touchUpInside)
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(15)
            make.width.equalTo(20)
            make.height.equalTo(40)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "查看路线"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self).offset(30)
        }
        
        if UI_IS_IPHONEX {
            backButton.snp.updateConstraints({ (make) in
                make.top.equalTo(self).offset(40)
            })
            
            titleLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(self).offset(40)
            })
        }
        
        let startLabel = UILabel()
        startLabel.text = "从"
        startLabel.font = UIFont.systemFont(ofSize: 15)
        startLabel.textColor = UIColor.white
        self.addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(backButton.snp.bottom).offset(22)
            make.width.equalTo(15)
        }
        
        let startImageView = UIImageView()
        startImageView.image = UIImage(named:"location_bg_icon")
        self.addSubview(startImageView)
        startImageView.snp.makeConstraints { (make) in
            make.left.equalTo(startLabel.snp.right).offset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.right.equalTo(self).offset(-55)
            make.height.equalTo(31)
        }
        
        startLocationLabel = UILabel()
        startLocationLabel?.text = MyLocationTitle
        startLocationLabel?.textColor = LOCATION_Color
        startLocationLabel?.font = UIFont.systemFont(ofSize: 15)
        startImageView.addSubview(startLocationLabel!)
        startLocationLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(startImageView.snp.left).offset(15)
            make.centerY.equalTo(startImageView.snp.centerY)
            make.right.equalTo(startImageView.snp.right).offset(-15)
        })
        
        let endLabel = UILabel()
        endLabel.text = "到"
        endLabel.font = UIFont.systemFont(ofSize: 15)
        endLabel.textColor = UIColor.white
        self.addSubview(endLabel)
        endLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(startLabel.snp.bottom).offset(24)
            make.width.equalTo(15)
        }
        
        let endImageView = UIImageView()
        endImageView.image = UIImage(named:"location_bg_icon")
        self.addSubview(endImageView)
        endImageView.snp.makeConstraints { (make) in
            make.left.equalTo(endLabel.snp.right).offset(14)
            make.top.equalTo(startImageView.snp.bottom).offset(11)
            make.right.equalTo(startImageView.snp.right).offset(0)
            make.height.equalTo(31)
        }
        
        endLocationLabel = UILabel()
        endLocationLabel?.textColor = LOCATION_Color
        endLocationLabel?.font = UIFont.systemFont(ofSize: 15)
        endImageView.addSubview(endLocationLabel!)
        endLocationLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(endImageView.snp.left).offset(15)
            make.centerY.equalTo(endImageView.snp.centerY)
            make.right.equalTo(endImageView.snp.right).offset(-15)
        })
        
        let changeBtn = UIButton()
        changeBtn.setImage(UIImage(named:"change_icon"), for: .normal)
        changeBtn.addTarget(self, action: #selector(changeLocation), for: .touchUpInside)
        self.addSubview(changeBtn)
        changeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(startImageView.snp.right).offset(8)
            make.top.equalTo(self).offset(95)
        }
        
        let busButton = UIButton()
        busButton.setTitle(BusTitle, for: .normal)
        busButton.tag = 101
        busButton.setTitleColor(UIColor.white, for: .normal)
        busButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        busButton.addTarget(self, action: #selector(showRoute(sender:)), for: .touchUpInside)
        self.addSubview(busButton)
        busButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(50)
            make.top.equalTo(endImageView.snp.bottom).offset(15)
            make.width.equalTo(35)
        }
        
        lineImageView = UIImageView()
        lineImageView?.image = UIImage(named:"xiahuaxian_icon")
        self.addSubview(lineImageView!)
        lineImageView?.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(47)
            make.top.equalTo(busButton.snp.bottom).offset(1)
        }
        
        let width = (UIScreen.main.bounds.size.width - 240) / 3
        
        let carButton = UIButton()
        carButton.setTitle(CarTitle, for: .normal)
        carButton.tag = 102
        carButton.setTitleColor(UIColor.white, for: .normal)
        carButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        carButton.addTarget(self, action: #selector(showRoute(sender:)), for: .touchUpInside)
        self.addSubview(carButton)
        carButton.snp.makeConstraints { (make) in
            make.left.equalTo(busButton.snp.right).offset(width)
            make.top.equalTo(busButton.snp.top).offset(0)
            make.width.equalTo(35)
        }
        
        let walkButton = UIButton()
        walkButton.setTitle(WalkTitle, for: .normal)
        walkButton.tag = 103
        walkButton.setTitleColor(UIColor.white, for: .normal)
        walkButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        walkButton.addTarget(self, action: #selector(showRoute(sender:)), for: .touchUpInside)
        self.addSubview(walkButton)
        walkButton.snp.makeConstraints { (make) in
            make.left.equalTo(carButton.snp.right).offset(width)
            make.top.equalTo(busButton.snp.top).offset(0)
            make.width.equalTo(35)
        }
        
        let ridingButton = UIButton()
        ridingButton.setTitle(RidingTitle, for: .normal)
        ridingButton.tag = 104
        ridingButton.setTitleColor(UIColor.white, for: .normal)
        ridingButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        ridingButton.addTarget(self, action: #selector(showRoute(sender:)), for: .touchUpInside)
        self.addSubview(ridingButton)
        ridingButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-50)
            make.top.equalTo(busButton.snp.top).offset(0)
            make.width.equalTo(35)
        }
        
    }
    
    
    override var  frame:(CGRect){
        
        didSet{
            let k_w = UIScreen.main.bounds.size.width
            var height = 190
            if UI_IS_IPHONEX {
                height = 200
            }
            
            let newFrame = CGRect(x:0,y:0,width:Int(k_w),height:height)
            super.frame = newFrame
        }
    }
        
}
extension JYD_SelectPathHeaderView{
    
    //交换起始位置
    @objc func changeLocation(){
        
        if delegate != nil {
            let temp = startLocationLabel?.text
            startLocationLabel?.text = endLocationLabel?.text
            endLocationLabel?.text = temp

            delegate?.changeLocationBtn(startLocation: (startLocationLabel?.text)!, endLocation: (endLocationLabel?.text)!)
        }
    }
    
    //展示路线
    @objc func showRoute(sender: UIButton){
        
        let x = sender.frame.origin.x

        if delegate != nil {
            lineImageView?.snp.updateConstraints({ (make) in
                make.left.equalTo(self).offset(x - 2)
            })
            delegate?.showRoute(tag: sender.tag)
        }
    }
    
    //返回按钮
    @objc func back(){
        
        if delegate != nil {
            delegate?.back()
        }
    }
}
