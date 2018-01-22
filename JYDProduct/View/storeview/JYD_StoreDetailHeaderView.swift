//
//  JYD_StoreDetailHeaderView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

typealias MakingCallStoreTel = () -> Void
class JYD_StoreDetailHeaderView: UIView,NibLoadProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var telImageView: UIImageView!
    
    var callStoreTel:MakingCallStoreTel?
    
    override func awakeFromNib() {
        self.titleLabel.font = UIFont.systemFont(ofSize: APPTool.obtainDisplaySize(size: 15))
        self.telLabel.font = UIFont.systemFont(ofSize: APPTool.obtainDisplaySize(size: 13))
        
        let telTap = UITapGestureRecognizer.init(target: self, action: #selector(userTelTapSender))
        telImageView.addGestureRecognizer(telTap)
    }
    
    @objc func userTelTapSender (){
        if callStoreTel != nil{
            callStoreTel!()
        }
    }
    
    func setContent(title:String,time:String,address:String,amount:String,telStr:String)  {
        self.titleLabel.text = title
        self.timeLabel.text = time
        self.addressLabel.text = address
        self.amountLabel.text = amount
        self.telLabel.text = telStr
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
