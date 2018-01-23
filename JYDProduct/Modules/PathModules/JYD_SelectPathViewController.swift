//
//  JYD_SelectPathViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit
import MBProgressHUD

class JYD_SelectPathViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,JYD_SelectPathHeaderDelegate,BMKRouteSearchDelegate,MBProgressHUDDelegate{
    
    //btnTag值：不同的交通工具
    var buttonTag : String? = "101"
    var _routeSearch : BMKRouteSearch?
    //数据的数组
    var dataArray : NSMutableArray = []
    //步行的路程数组
    var walkArray : NSMutableArray = []
    //开始位置
    var startCoord: CLLocationCoordinate2D?
    //结束位置
    var endCoord : CLLocationCoordinate2D?
    //开始位置名称
//    var starLoactionName : String?
    //结束位置名称
    var endLoactionName : String = ""
    
    //关于路线处理handler
    var handler:JYD_PathHandler?
    //加载等待视图
    var waitView  = MBProgressHUD()
    //地图handler
    var Maphandler:JYD_MapHandler?
    
    let tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
        tableView.isScrollEnabled = true
        tableView.backgroundColor = VIEWCONTROLLERBG_Color
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }else{
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        
        let headerView = JYD_SelectPathHeaderView()
        headerView.backgroundColor = LOCATION_Color
        headerView.delegate = self
        headerView.startLocationLabel?.text = "我的位置"
        headerView.endLocationLabel?.text = endLoactionName
        tableView.tableHeaderView = headerView
        
        let footerView = setFooterView()
        footerView.backgroundColor = UIColor.clear
        footerView.frame = CGRect(x:0,y:0,width:_k_w,height:109)
        tableView.tableFooterView = footerView
        
        tableView.tableFooterView?.isHidden = true
        
        handler = JYD_PathHandler.init()
        Maphandler = JYD_MapHandler.init()
        Maphandler?.vc = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _routeSearch = BMKRouteSearch()
        _routeSearch?.delegate = self
//        startCoord = CLLocationCoordinate2DMake(31.40, 121.24)
//        endCoord = CLLocationCoordinate2DMake(31.15, 121.10)
        dataArray.removeAllObjects()
        showMapRoute(tag: (Int)(buttonTag!)!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _routeSearch?.delegate = nil
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:获取公交路线
    func setBusRoute(startCoord:CLLocationCoordinate2D,endCoord:CLLocationCoordinate2D){
    
        //嘉定
        let start = BMKPlanNode()
        start.pt = startCoord
//        start.cityName = "上海"
        //青浦
        let end = BMKPlanNode()
        end.pt = endCoord
//        end.cityName = "上海"
        let option = BMKMassTransitRoutePlanOption()
        option.from = start
        option.to = end
        let flag = _routeSearch?.massTransitSearch(option)
        
        if flag! {
            DPrint(message: "公交交通检索（支持垮城）发送成功")
        }else{
            DPrint(message: "公交交通检索（支持垮城）发送失败")
        }
    }
    
    //MARK:获取步行路线
    func setWalkRoute(startCoord:CLLocationCoordinate2D,endCoord:CLLocationCoordinate2D){
        
        let start = BMKPlanNode()
        start.pt = startCoord
//        start.cityName = "北京"
        let end = BMKPlanNode()
        end.pt = endCoord
//        end.cityName = "北京"
        let walkingRouteSearchOption = BMKWalkingRoutePlanOption()
        walkingRouteSearchOption.from = start
        walkingRouteSearchOption.to = end
        let flag = _routeSearch?.walkingSearch(walkingRouteSearchOption)
        if flag! {
            DPrint(message: "walk检索发送成功")
        }else{
            DPrint(message: "walk检索发送失败")
        }
    }
    
    //MARK:获取驾车路线
    func setCarRoute(startCoord:CLLocationCoordinate2D,endCoord:CLLocationCoordinate2D){
        
        let start = BMKPlanNode()
        start.pt = startCoord
//        start.cityName = "徐家汇"
        let end = BMKPlanNode()
        end.pt = endCoord
//        end.cityName = "波司登"
        let drivingRouteSearchOption = BMKDrivingRoutePlanOption()
        drivingRouteSearchOption.from = start
        drivingRouteSearchOption.to = end
        drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE //不获取路况信息
        let flag = _routeSearch?.drivingSearch(drivingRouteSearchOption)
        if flag! {
            DPrint(message: "car检索发送成功")
        }else{
            DPrint(message: "car检索发送失败")
        }
        
        
    }
    //MARK:获取骑车路线
    func setRidingRoute(startCoord:CLLocationCoordinate2D,endCoord:CLLocationCoordinate2D){
        
        let start = BMKPlanNode()
        start.pt = startCoord
//        start.cityName = "虹桥火车站"
        let end = BMKPlanNode()
        end.pt = endCoord
//        end.cityName = "上海火车站"
        let option = BMKRidingRoutePlanOption()
        option.from = start
        option.to = end
        let flag = _routeSearch?.ridingSearch(option)
        if flag! {
            DPrint(message: "骑行规划检索发送成功")
        }else{
            DPrint(message: "骑行规划检索发送失败")
        }
        
    }
    
    //设置底部按钮
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
            make.width.equalTo(_k_w - 96)
            make.centerX.equalTo(footerView.snp.centerX)
            make.height.equalTo(42)
            make.top.equalTo(footerView.snp.top).offset(67)
        }
        return footerView
        
    }
    
    //底部按钮点击事件
    @objc func footerBtnClick(){
        
        let tag = Int(buttonTag!)
        switch tag {
        case 102?:
            Maphandler?.startExternalMaps(.MapDriving, fromLocation: APPUtilityInfo.shareInstance.userCurrentLocation!, fromName: "我的位置", toLocation: endCoord!, toName: endLoactionName)
            break
        case 103?:
            Maphandler?.startExternalMaps(.MapWalk, fromLocation: APPUtilityInfo.shareInstance.userCurrentLocation!, fromName: "我的位置", toLocation: endCoord!, toName: endLoactionName)
            break
        case 104?:
            Maphandler?.startExternalMaps(.MapRide, fromLocation: APPUtilityInfo.shareInstance.userCurrentLocation!, fromName: "我的位置", toLocation: endCoord!, toName: endLoactionName)
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataArray.count > 0 {
            return dataArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = VIEWCONTROLLERBG_Color
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:JYD_SelectePathCell! = tableView.dequeueReusableCell(withIdentifier:"cellId") as? JYD_SelectePathCell
        if cell == nil {
            cell = JYD_SelectePathCell.init(style: .default, reuseIdentifier: "cellId")
        }
        cell.selectionStyle = .none
        cell.type = buttonTag
        if dataArray.count <= 0 {
            return cell
        }
        
        setCell(cell: cell, tag: buttonTag!, index: indexPath.section)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let controller = JYD_PathDetailViewController()
        setController(controller:controller , tag: buttonTag!, index: indexPath.section)
    
    }
    
    //cell点击事件
    func setController(controller:JYD_PathDetailViewController ,tag: String , index:Int){
        
        let tag1 = Int(tag)
        controller.tag = tag1
        switch tag1 {
        case 101?:
            let routeLine = dataArray[index] as! BMKMassTransitRouteLine
            controller.busRoute = routeLine
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 102?:
            let routeLine = dataArray[index] as! BMKDrivingRouteLine
            controller.drivingRoute = routeLine
            controller.drivingDesc = setCarDesc(index: index)
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 103?:
            let routeLine = dataArray[index] as! BMKWalkingRouteLine
            controller.walkingRoute = routeLine
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 104?:
            let routeLine = dataArray[index] as! BMKRidingRouteLine
            controller.ridingRoute = routeLine
            self.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            break
        }
    }
    
    //设置cell内容
    func setCell(cell :JYD_SelectePathCell ,tag : String,index : Int){
        
        let tag1 = Int(tag)
        switch tag1 {
        case 101?:
            
            let routeLine = dataArray[index] as! BMKMassTransitRouteLine
            let route = handler?.getBusDetailRoute(routeLine: routeLine)
            let timeStr = handler?.calculateTime(duration: routeLine.duration)
            let distance = handler?.calculateDistance(distance: Int(routeLine.distance))
            cell.leftLabel?.text = "\(index + 1)"
            cell.routeLabel?.text = "\(route!)"
            cell.routeLabel?.numberOfLines = 0
            walkArray = (handler?.getBusWaklingRoute(routeLine: routeLine))!
            let walk = handler?.calculateWalkingDistance(walkArray: walkArray)
            let walkDistance = handler?.calculateDistance(distance: walk!)

            let walkStr = String(format:"%.2f",walkDistance!)
            cell.walkLabel?.text = WalkTitle + walkStr + Unit
           
            let str = (cell.routeLabel?.text)! as NSString
            
            var width = str.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)]).width
            if UI_IS_IPHONE5 {
                width = str.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12)]).width
            }
            
            if width > UIScreen.main.bounds.size.width - 88 {
                
                cell.routeLabel?.snp.updateConstraints({ (make) in
                    make.top.equalTo(cell.snp.top).offset(10)
                })
            }

            cell.timeLabel?.text = "\(timeStr!)"
            let distanceStr = String(format:"%.2f",distance!)
            cell.distanceLabel?.text = distanceStr + Unit
            break
            
        case 102?:
            let routeLine = dataArray[index] as! BMKDrivingRouteLine
            let timeStr = handler?.calculateTime(duration: routeLine.duration)
            let distance = handler?.calculateDistance(distance: Int(routeLine.distance))
            cell.leftLabel?.text = "\(index + 1)"
            cell.routeLabel?.text = setCarDesc(index: index)
            cell.timeLabel?.text = "\(timeStr!)"
            let distanceStr = String(format:"%.2f",distance!)
            cell.distanceLabel?.text = distanceStr + Unit
            break
        case 103?:
            let routeLine = dataArray[index] as! BMKWalkingRouteLine
            let timeStr = handler?.calculateTime(duration: routeLine.duration)
            let distance = handler?.calculateDistance(distance: Int(routeLine.distance))
            cell.leftLabel?.text = "\(index + 1)"
            cell.timeLabel?.text = WalkTitle + "\(timeStr!)"
            let distanceStr = String(format:"%.2f",distance!)
            cell.distanceLabel?.text = distanceStr + Unit
            
            break
        case 104?:
            let routeLine = dataArray[index] as! BMKRidingRouteLine
            let timeStr = handler?.calculateTime(duration: routeLine.duration)
            let distance = handler?.calculateDistance(distance: Int(routeLine.distance))
            
            cell.leftLabel?.text = "\(index + 1)"
            let distanceStr = String(format:"%.2f",distance!)
            cell.timeLabel?.text = RidingTitle + "\(timeStr!)"
            cell.distanceLabel?.text = distanceStr + Unit

            break
        default:
            break
        }
    }
    
    //自驾标题描述
    func setCarDesc(index :Int)->String{
        var desc = ""
        if index == 0 {
            desc = "用时最少"
        }else if index == 1{
            desc = "常规路线"
        }else{
            desc = "方案" + "\(index + 1)"
        }
        return desc
        
    }

    
    //位置交换按钮
    func changeLocationBtn(startLocation: String, endLocation: String) {
        
        let temp = startCoord!
        startCoord! = endCoord!
        endCoord = temp
        showRoute(tag: (Int)(buttonTag!)!)
        
//        print(startLocation,endLocation)
    }

    //各种工具切换
    func showRoute(tag: Int) {
        
        buttonTag = "\(tag)"
        tableView.tableFooterView?.isHidden = false
        if tag == 101 {
            tableView.tableFooterView?.isHidden = true
        }
        dataArray.removeAllObjects()
        tableView.reloadData()
        showMapRoute(tag: tag)
    }

   
    func showMapRoute(tag : Int){
    
        loading()
        switch tag {
        case 101:
            setBusRoute(startCoord: startCoord!, endCoord: endCoord!)
            break
        case 102:
            setCarRoute(startCoord: startCoord!, endCoord: endCoord!)
            break
        case 103:
            setWalkRoute(startCoord: startCoord!, endCoord: endCoord!)
            break
        case 104:
            setRidingRoute(startCoord: startCoord!, endCoord: endCoord!)
            break
        default:
            break
        }
    }
    
    func back() {
        popBack()
    }
    
    //加载等待视图
    func loading(){
        MBPAlertView.shareInstance.showWaitView(view: self.view)
    }
    
    //移除等待视图
    func removeLoading()  {
        MBPAlertView.shareInstance.removeWaitView()
    }
    
    
    //MARK:BMKRouteSearch代理
    /**
     *返回公共交通路线检索结果（new）
     *@param searcher 搜索对象
     *@param result 搜索结果，类型为BMKMassTransitRouteResult
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetMassTransitRouteResult(_ searcher: BMKRouteSearch!, result: BMKMassTransitRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            
            for index in 0..<result.routes.count{
                let routeLine = result.routes[index] as! BMKMassTransitRouteLine
                dataArray.add(routeLine)
            }
            
            removeLoading()
            tableView.reloadData()
            
        }else{
            
            removeLoading()
            MBPAlertView.shareInstance.showTextOnly(message: "检索失败", view: self.view)

        }
    }
    /**
     *返回步行搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果，类型为BMKWalkingRouteResult
     *@param error 错误号，@see BMKSearchErrorCode
     */
    
    func onGetWalkingRouteResult(_ searcher: BMKRouteSearch!, result: BMKWalkingRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            
            for index in 0..<result.routes.count{
                let routeLine = result.routes[index] as! BMKWalkingRouteLine
                dataArray.add(routeLine)
            }

            removeLoading()
            tableView.reloadData()
            
        }else{
            
            removeLoading()
            MBPAlertView.shareInstance.showTextOnly(message: "检索失败", view: self.view)
        }
    }
    
    /**
     *返回驾乘搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果，类型为BMKDrivingRouteResult
     *@param error 错误号，@see BMKSearchErrorCode
     */
    
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            
            for index in 0..<result.routes.count{
                let routeLine = result.routes[index] as! BMKDrivingRouteLine
                dataArray.add(routeLine)
                
            }
            handler?.getCarDetailRoute(dataArray: dataArray)
            removeLoading()
            tableView.reloadData()
        }else{
            
            removeLoading()
            MBPAlertView.shareInstance.showTextOnly(message: "检索失败", view: self.view)
    
        }
    }

    /**
     *返回骑行搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果，类型为BMKRidingRouteResult
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetRidingRouteResult(_ searcher: BMKRouteSearch!, result: BMKRidingRouteResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            
            for index in 0..<result.routes.count{
                let routeLine = result.routes[index] as! BMKRidingRouteLine
                dataArray.add(routeLine)
            }
            
            removeLoading()
            tableView.reloadData()
        }else{
            
            removeLoading()
            MBPAlertView.shareInstance.showTextOnly(message: "检索失败", view: self.view)
    
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
