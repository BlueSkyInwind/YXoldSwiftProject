//
//  JYD_SelectPathViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_SelectPathViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,JYD_SelectPathHeaderDelegate{
    
    var buttonTag : String? = "101"
    let tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        
        let bgView = UIView()
        bgView.backgroundColor = LOCATION_Color
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(0)
            make.top.equalTo(self.view).offset(-20)
            make.right.equalTo(self.view).offset(0)
            make.height.equalTo(20)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TABLEVIEWBG_Color
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let headerView = JYD_SelectPathHeaderView()
        headerView.backgroundColor = LOCATION_Color
        headerView.delegate = self
        headerView.startLocationLabel?.text = "我的位置"
        headerView.endLocationLabel?.text = "星巴克门店"
        tableView.tableHeaderView = headerView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = TABLEVIEWBG_Color
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:JYD_SelectePathCell! = tableView.dequeueReusableCell(withIdentifier:"cellId") as? JYD_SelectePathCell
        if cell == nil {
            cell = JYD_SelectePathCell.init(style: .default, reuseIdentifier: "cellId")
        }
        cell.selectionStyle = .none
        cell.type = buttonTag
        
        cell.leftLabel?.text = "1"
        cell.routeLabel?.text = "地铁10号线--地铁2号线--83路"
        cell.timeLabel?.text = "1小时26分钟"
        cell.distanceLabel?.text = "10.4km"
        cell.walkLabel?.text = "步行1.3km"
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func changeLocationBtn(startLocation: String, endLocation: String) {
        print(startLocation,endLocation)
    }

    func showRoute(tag: Int) {
        
        buttonTag = "\(tag)"
        tableView.reloadData()
    
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
