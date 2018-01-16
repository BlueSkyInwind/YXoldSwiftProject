//
//  JYD_SelectPathDetailCell.swift
//  JYDProduct
//
//  Created by sxp on 2018/1/10.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_SelectPathDetailCell: UITableViewCell {

    //
    var lineView : UIView?
    //内容
    var contentLabel : UILabel?
    //交通工具的图片
    var leftImageView : UIImageView?
    
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
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JYD_SelectPathDetailCell{
    fileprivate func setupUI(){
        
        leftImageView = UIImageView()
        self.addSubview(leftImageView!)
        leftImageView?.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(20)
            make.top.equalTo(self.snp.top).offset(15)
            make.height.equalTo(18)
            make.width.equalTo(14)
        }
        
        contentLabel = UILabel()
        contentLabel?.textColor = PaopaoTitleColor
        contentLabel?.font = UIFont.systemFont(ofSize: 13)
        contentLabel?.numberOfLines = 0
        self.addSubview(contentLabel!)
        contentLabel?.snp.makeConstraints { (make) in
            make.left.equalTo((leftImageView?.snp.right)!).offset(20)
            make.top.equalTo(self.snp.top).offset(2)
            make.height.equalTo(40)
            make.right.equalTo(self.snp.right).offset(-27)
        }
        
        lineView = UIView()
        lineView?.backgroundColor = SelectePathDetailLine_Color
        self.addSubview(lineView!)
        lineView?.snp.makeConstraints({ (make) in
            make.left.equalTo((contentLabel?.snp.left)!).offset(0)
            make.right.equalTo(self.snp.right).offset(-35)
            make.bottom.equalTo(self.snp.bottom).offset(-1)
            make.height.equalTo(1)
        })
    }
}
