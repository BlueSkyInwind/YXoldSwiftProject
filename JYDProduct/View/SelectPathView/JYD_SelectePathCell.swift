//
//  JYD_SelectePathCell.swift
//  JYDProduct
//
//  Created by sxp on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_SelectePathCell: UITableViewCell {

    //左边数字
    var leftLabel : UILabel?
    //路线
    var routeLabel : UILabel?
    //时间
    var timeLabel : UILabel?
    //步行
    var walkLabel : UILabel?
    //路线总距离
    var distanceLabel : UILabel?
    //交通工具type
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
        
        //101：公交车  102：自驾 103：步行 104：自行车
        let type = Int(type)
        switch type {
        case 101?:
            setBusUI()
        case 102?:
            setCarUI()
        case 103?,104?:
            setWalkUI()
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    //公交车的UI
    fileprivate func setBusUI(){
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named:"route_cell_bg_icon")
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(75)
        }
        
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
        routeLabel?.textColor = StoreDetailImageTitle_Color
        routeLabel?.font = UIFont.systemFont(ofSize: 15)
        if UI_IS_IPHONE5 {
            routeLabel?.font = UIFont.systemFont(ofSize: 12)
        }
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
            walkLabel?.snp.updateConstraints({ (make) in
                make.left.equalTo((distanceLabel?.snp.right)!).offset(25)
            })
        }
        
        if UI_IS_IPHONE5 {
            distanceLabel?.snp.updateConstraints({ (make) in
                make.left.equalTo((timeLabel?.snp.right)!).offset(13)
            })
            walkLabel?.snp.updateConstraints({ (make) in
                make.left.equalTo((distanceLabel?.snp.right)!).offset(15)
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
    
    //自驾的UI
    fileprivate func setCarUI(){
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named:"route_cell_bg_icon")
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(75)
        }
        
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
        routeLabel?.textColor = StoreDetailImageTitle_Color
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

    //步行和骑车的UI
    fileprivate func setWalkUI(){
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named:"route_cell_bg_icon")
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(75)
        }
        
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
        timeLabel?.textColor = StoreDetailImageTitle_Color
        timeLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        if UI_IS_IPHONE5 {
            timeLabel?.font = UIFont.systemFont(ofSize: 13)
        }
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
