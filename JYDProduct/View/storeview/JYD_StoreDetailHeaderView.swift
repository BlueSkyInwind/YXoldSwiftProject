//
//  JYD_StoreDetailHeaderView.swift
//  JYDProduct
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_StoreDetailHeaderView: UIView,NibLoadProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        self.titleLabel.font = UIFont.FitBoldSystemFontOfSize(fontSize: 15)

    }
    
    func setContent(title:String,time:String,address:String,amount:String)  {
        self.titleLabel.text = title
        self.timeLabel.text = time
        self.addressLabel.text = address
        self.amountLabel.text = amount
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
