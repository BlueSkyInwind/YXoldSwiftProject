//
//  JYD_SelectPathDetailRouterView.swift
//  JYDProduct
//
//  Created by sxp on 2018/1/8.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

@objc protocol JYD_SelectPathDetailRouterViewDelegate : NSObjectProtocol {
    
    //图标按钮
    func directionImage(isDown : Bool)
    
}

class JYD_SelectPathDetailRouterView: UIView ,UITableViewDelegate,UITableViewDataSource{

    var routerLabel : UILabel?
    var timeLabel : UILabel?
    var distanceLabel : UILabel?
    var walkLabel : UILabel?
    var directionButton : UIButton?
    var lineView : UIView?
    var contentLabel : UILabel?
    var dataArray : NSMutableArray = []

    @objc weak var delegate : JYD_SelectPathDetailRouterViewDelegate?
    
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

extension JYD_SelectPathDetailRouterView{
    fileprivate func setupUI(){
        
        let pathBgView = UIView()
        pathBgView.backgroundColor = TABLEVIEWBG_Color
        self.addSubview(pathBgView)
        pathBgView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.top.equalTo(self).offset(0)
            make.height.equalTo(88)
        }
        
        let pathView = UIView()
        pathView.backgroundColor = UIColor.white
        pathBgView.addSubview(pathView)
        pathView.snp.makeConstraints { (make) in
            make.left.equalTo(pathBgView.snp.left).offset(0)
            make.right.equalTo(pathBgView.snp.right).offset(0)
            make.top.equalTo(pathBgView.snp.top).offset(0)
            make.height.equalTo(85)
        }
        
        directionButton = UIButton.init(type: UIButtonType.custom)
        directionButton?.setImage(UIImage(named:"down_icon"), for: .normal)
        directionButton?.addTarget(self, action: #selector(directionButtonClick), for: .touchUpInside)
        pathView.addSubview(directionButton!)
        directionButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(pathView.snp.top).offset(3)
            make.centerX.equalTo(pathView.snp.centerX)
        })
        
        routerLabel = UILabel()
        routerLabel?.textColor = SelectPathRoute_Color
        routerLabel?.font = UIFont.systemFont(ofSize: 15)
        routerLabel?.numberOfLines = 0
        pathView.addSubview(routerLabel!)
        routerLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(pathView.snp.left).offset(20)
            make.top.equalTo((directionButton?.snp.bottom)!).offset(0)
            make.right.equalTo(pathView.snp.right).offset(-20)
        })
        
        timeLabel = UILabel()
        timeLabel?.textColor = SelectPathTime_Color
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        pathView.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((routerLabel?.snp.left)!).offset(0)
//            make.top.equalTo((routerLabel?.snp.bottom)!).offset(11)
            make.bottom.equalTo(pathView.snp.bottom).offset(-10)
        })
        
        distanceLabel = UILabel()
        distanceLabel?.textColor = SelectPathTime_Color
        distanceLabel?.font = UIFont.systemFont(ofSize: 12)
        pathView.addSubview(distanceLabel!)
        distanceLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((timeLabel?.snp.right)!).offset(43)
            make.top.equalTo((timeLabel?.snp.top)!).offset(0)
        })
        
        walkLabel = UILabel()
        walkLabel?.textColor = SelectPathTime_Color
        walkLabel?.font = UIFont.systemFont(ofSize: 12)
        pathView.addSubview(walkLabel!)
        walkLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((distanceLabel?.snp.right)!).offset(49)
            make.top.equalTo((timeLabel?.snp.top)!).offset(0)
        })
        
        let detailTab = UITableView()
        detailTab.delegate = self
        detailTab.dataSource = self
        detailTab.showsHorizontalScrollIndicator = false
        detailTab.isScrollEnabled = true
        detailTab.separatorStyle = .none
        self.addSubview(detailTab)
        detailTab.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.top.equalTo(pathBgView.snp.bottom).offset(0)
            make.height.equalTo(150)
        }
        
//        for index in 0..<3 {
//
//            let contentView = setContentView()
//            contentLabel?.text = "乘坐地铁10号线，在江湾体育场站上车，经过11站到达老西门站下车"
//            self.addSubview(contentView)
//            contentView.snp.makeConstraints({ (make) in
//                make.left.equalTo(self).offset(0)
//                make.right.equalTo(self).offset(0)
//                make.top.equalTo(pathBgView.snp.bottom).offset(index * 50)
//                make.height.equalTo(50)
//            })
//
//            if index == 2{
//                lineView?.isHidden = true
//            }
//        }
    }
    
    @objc func directionButtonClick(){
        
        directionButton?.isSelected = !(directionButton?.isSelected)!
        
        if delegate != nil{
            delegate?.directionImage(isDown: (directionButton?.isSelected)!)
        }
        
        print("点击小图标")
    }
}

extension JYD_SelectPathDetailRouterView{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.count > 0 {
            return dataArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:JYD_SelectPathDetailCell! = tableView.dequeueReusableCell(withIdentifier:"homeRefuseCell") as? JYD_SelectPathDetailCell
        if cell == nil {
            cell = JYD_SelectPathDetailCell.init(style: .default, reuseIdentifier: "homeRefuseCell")
        }
        cell.selectionStyle = .none
        cell.isSelected = false;
        cell.contentLabel?.text = dataArray[indexPath.row] as? String
        cell.lineView?.isHidden = false
        if indexPath.row == dataArray.count - 1{
            
            cell.lineView?.isHidden = true
        }
        
        return cell
    }
}

extension JYD_SelectPathDetailRouterView{
    
    fileprivate func setContentView() -> UIView{
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named:"bus_icon")
        contentView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(20)
            make.top.equalTo(contentView.snp.top).offset(15)
            make.height.equalTo(18)
            make.width.equalTo(14)
        }
        
        contentLabel = UILabel()
        contentLabel?.textColor = PaopaoTitleColor
        contentLabel?.font = UIFont.systemFont(ofSize: 13)
        contentLabel?.numberOfLines = 0
        contentView.addSubview(contentLabel!)
        contentLabel?.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp.right).offset(20)
            make.top.equalTo(contentView.snp.top).offset(2)
            make.height.equalTo(40)
            make.right.equalTo(contentView.snp.right).offset(-27)
        }
        
        lineView = UIView()
        lineView?.backgroundColor = SelectePathDetailLine_Color
        contentView.addSubview(lineView!)
        lineView?.snp.makeConstraints({ (make) in
            make.left.equalTo((contentLabel?.snp.left)!).offset(0)
            make.right.equalTo(contentView.snp.right).offset(-35)
            make.bottom.equalTo(contentView.snp.bottom).offset(-1)
            make.height.equalTo(1)
        })
        return contentView
    }
}


