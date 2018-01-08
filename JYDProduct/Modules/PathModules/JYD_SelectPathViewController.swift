//
//  JYD_SelectPathViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_SelectPathViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,JYD_SelectPathHeaderDelegate,BMKRouteSearchDelegate{
    
    var buttonTag : String? = "101"
    var _routeSearch : BMKRouteSearch?
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
        
        let footerView = setFooterView()
        footerView.backgroundColor = UIColor.clear
        footerView.frame = CGRect(x:0,y:0,width:_k_w,height:109)
        tableView.tableFooterView = footerView
        
        tableView.tableFooterView?.isHidden = true
        
        setWalkRoute()
    }
    
    
    func setBusRoute(){
        
        
        
    }
    
    func setWalkRoute(){
        
        _routeSearch = BMKRouteSearch()
        _routeSearch?.delegate = self
        let start = BMKPlanNode()
        start.name = "上海"
        start.cityName = "徐家汇"
        let end = BMKPlanNode()
        end.name = "上海"
        end.cityName = "波司登"
        let walkingRouteSearchOption = BMKWalkingRoutePlanOption()
        walkingRouteSearchOption.from = start
        walkingRouteSearchOption.to = end
        let flag = _routeSearch?.walkingSearch(walkingRouteSearchOption)
        if flag! {
            print("walk检索发送成功")
        }else{
            print("walk检索发送失败")
        }
    }
    
    func setFooterView() -> UIView{
        
        let footerView = UIView()
        let footerBtn = UIButton()
        footerBtn.setTitle("使用本地地图导航", for: .normal)
        footerBtn.setTitleColor(UIColor.white, for: .normal)
        footerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        footerBtn.setBackgroundImage(UIImage(named:"buttonBg_icon"), for: .normal)
        footerBtn.addTarget(self, action: #selector(footerBtnClick), for: .touchUpInside)
        footerView.addSubview(footerBtn)
        footerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(footerView.snp.left).offset(48)
            make.right.equalTo(footerView.snp.right).offset(-48)
            make.height.equalTo(42)
            make.top.equalTo(footerView.snp.top).offset(67)
        }
        return footerView
        
    }
    
    @objc func footerBtnClick(){
        
        let controller = JYD_PathDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
        print("底部按钮")
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
        
        let controller = JYD_PathDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func changeLocationBtn(startLocation: String, endLocation: String) {
        print(startLocation,endLocation)
    }

    func showRoute(tag: Int) {
        
        buttonTag = "\(tag)"
        tableView.tableFooterView?.isHidden = false
        if tag == 101 {
            tableView.tableFooterView?.isHidden = true
        }
        tableView.reloadData()
    
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    func back() {
        popBack()
    }
    
    
    //MARK:BMKRouteSearch代理
    /**
     *返回步行搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果，类型为BMKWalkingRouteResult
     *@param error 错误号，@see BMKSearchErrorCode
     */
    
    func onGetWalkingRouteResult(_ searcher: BMKRouteSearch!, result: BMKWalkingRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            print("成功获取结果")
            print(result)
            
            let plan = result.routes[0] as! BMKWalkingRouteLine
        
            print(plan.distance,plan.duration.dates,plan.duration.hours,plan.duration.minutes,plan.duration.seconds)
        }else{
            print("检索失败")
        }
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
