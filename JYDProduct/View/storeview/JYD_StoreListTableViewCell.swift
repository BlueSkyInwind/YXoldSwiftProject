//
//  JYD_StoreListTableViewCell.swift
//  JYDProduct
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_StoreListTableViewCell: UITableViewCell {

    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var adressLabel:UILabel?
    var pathView:UIView?
    var pathIcon:UIImageView?
    var distanceLabel:UILabel?
    
    var pathTapClick:DisplayPathTapClick?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(displayPathClick))
        pathView?.addGestureRecognizer(tap)
    }
    
    func configureContent(title:String,time:String,address:String,distance:String)  {
        self.titleLabel?.text = title
        self.timeLabel?.text = time
        self.adressLabel?.text = address
        self.distanceLabel?.text = distance
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func  displayPathClick() {
        if pathTapClick != nil {
            pathTapClick!()
        }
    }

}

extension JYD_StoreListTableViewCell {
    
    func setUpUI()  {
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.FitBoldSystemFontOfSize(fontSize: 15)
        titleLabel?.textColor = homeBottomTitleColor
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo(self.snp.top).offset(APPTool.obtainDisplaySize(size: 15))
        })
        
        timeLabel = UILabel()
        timeLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 13)
        timeLabel?.textColor = homeBottomContentColor
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo((titleLabel?.snp.bottom)!).offset(APPTool.obtainDisplaySize(size: 8))
        })
        
        adressLabel = UILabel()
        adressLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 13)
        adressLabel?.textColor = homeBottomContentColor
        self.addSubview(adressLabel!)
        adressLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(APPTool.obtainDisplaySize(size: 20))
            make.top.equalTo((timeLabel?.snp.bottom)!).offset(APPTool.obtainDisplaySize(size: 8))
        })
        
        pathView = UIView()
        pathView?.backgroundColor = appMainBg
        self.addSubview(pathView!)
        pathView?.snp.makeConstraints({ (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(self.snp.height)
        })
        
        pathIcon = UIImageView()
        pathIcon?.image = UIImage.init(named: "path_Icon")
        pathIcon?.isUserInteractionEnabled  = true
        pathView?.addSubview(pathIcon!)
        pathIcon?.snp.makeConstraints({ (make) in
            make.centerX.equalTo((pathView?.snp.centerX)!)
            make.centerY.equalTo((pathView?.snp.centerY)!).offset(-10)
        })
        
        distanceLabel = UILabel()
        distanceLabel?.font = UIFont.FitSystemFontOfSize(fontSize: 12)
        distanceLabel?.textColor = UIColor.white
        pathView?.addSubview(distanceLabel!)
        distanceLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo((pathView?.snp.centerX)!)
            make.centerY.equalTo((pathView?.snp.centerY)!).offset(10)
        })
    }

}

