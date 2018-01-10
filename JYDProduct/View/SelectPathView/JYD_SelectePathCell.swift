//
//  JYD_SelectePathCell.swift
//  JYDProduct
//
//  Created by sxp on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_SelectePathCell: UITableViewCell {

    var leftLabel : UILabel?
    var routeLabel : UILabel?
    var timeLabel : UILabel?
    var walkLabel : UILabel?
    var distanceLabel : UILabel?
    
    @objc var type : String?{
        didSet(newValue){
            
            setCellType(type: type!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        type = "101"
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JYD_SelectePathCell{
    
    fileprivate func setCellType(type : String){
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        let type = Int(type)
        switch type {
        case 101?,104?:
            setBusUI()
        case 102?:
            setCarUI()
        case 103?:
            setWalkUI()
        case .none:
            break
        case .some(_):
            break
        }
        
    }
    fileprivate func setBusUI(){
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named:"tuoyuan_icon")
        self.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(19)
            make.height.equalTo(19)
        }
        
        leftLabel = UILabel()
        leftLabel?.textColor = UIColor.white
        leftLabel?.font = UIFont.systemFont(ofSize: 15)
        leftImageView.addSubview(leftLabel!)
        leftLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(leftImageView.snp.centerX)
            make.centerY.equalTo(leftImageView.snp.centerY)
        })
        
        routeLabel = UILabel()
        routeLabel?.textColor = SelectPathRoute_Color
        routeLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(routeLabel!)
        routeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(leftImageView.snp.right).offset(9)
            make.top.equalTo(self).offset(18)
            make.right.equalTo(self).offset(-40)
        })
        
        timeLabel = UILabel()
        timeLabel?.textColor = SelectPathTime_Color
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((routeLabel?.snp.left)!).offset(0)
            make.top.equalTo((routeLabel?.snp.bottom)!).offset(10)
        })
        
        distanceLabel = UILabel()
        distanceLabel?.textColor = SelectPathTime_Color
        distanceLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(distanceLabel!)
        distanceLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((timeLabel?.snp.right)!).offset(43)
            make.top.equalTo((routeLabel?.snp.bottom)!).offset(10)
        })
        
        
        walkLabel = UILabel()
        walkLabel?.textColor = SelectPathTime_Color
        walkLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(walkLabel!)
        walkLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((distanceLabel?.snp.right)!).offset(49)
            make.top.equalTo((routeLabel?.snp.bottom)!).offset(10)
        })
        
        if UI_IS_IPONE6 {
            distanceLabel?.snp.updateConstraints({ (make) in
                make.left.equalTo((timeLabel?.snp.right)!).offset(23)
            })
            walkLabel?.snp.makeConstraints({ (make) in
                make.left.equalTo((distanceLabel?.snp.right)!).offset(25)
            })
        }
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named:"arrow_Icon")
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    fileprivate func setCarUI(){
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named:"tuoyuan_icon")
        self.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(19)
            make.width.equalTo(19)
        }
        
        leftLabel = UILabel()
        leftLabel?.textColor = UIColor.white
        leftLabel?.font = UIFont.systemFont(ofSize: 15)
        leftImageView.addSubview(leftLabel!)
        leftLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(leftImageView.snp.centerX)
            make.centerY.equalTo(leftImageView.snp.centerY)
        })
        
        routeLabel = UILabel()
        routeLabel?.textColor = SelectPathRoute_Color
        routeLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(routeLabel!)
        routeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.top.equalTo(self).offset(20)
        })
        
        timeLabel = UILabel()
        timeLabel?.textColor = SelectPathTime_Color
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((routeLabel?.snp.left)!).offset(0)
            make.top.equalTo((routeLabel?.snp.bottom)!).offset(10)
        })
        
        distanceLabel = UILabel()
        distanceLabel?.textColor = SelectPathTime_Color
        distanceLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(distanceLabel!)
        distanceLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((timeLabel?.snp.right)!).offset(43)
            make.top.equalTo((routeLabel?.snp.bottom)!).offset(10)
        })
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named:"arrow_Icon")
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self.snp.centerY)
        }
    }

    fileprivate func setWalkUI(){
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named:"tuoyuan_icon")
        self.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(19)
            make.width.equalTo(19)
        }
        
        leftLabel = UILabel()
        leftLabel?.textColor = UIColor.white
        leftLabel?.font = UIFont.systemFont(ofSize: 15)
        leftImageView.addSubview(leftLabel!)
        leftLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(leftImageView.snp.centerX)
            make.centerY.equalTo(leftImageView.snp.centerY)
        })
        
        timeLabel = UILabel()
        timeLabel?.textColor = SelectPathRoute_Color
        timeLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        distanceLabel = UILabel()
        distanceLabel?.textColor = SelectPathTime_Color
        distanceLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(distanceLabel!)
        distanceLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((timeLabel?.snp.right)!).offset(43)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named:"arrow_Icon")
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
