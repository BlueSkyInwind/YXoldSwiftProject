//
//  JYD_StoreListViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_StoreListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView?
    
    var storeInfolists:[StoreListResult]?
    var storeListCell:JYD_StoreListTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Home_NavTitle
        self.addWhiteBackItem()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addWhiteNavStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        addNavStyle()
    }
    

    func configureView()  {
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = VIEWCONTROLLERBG_Color
        tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.view.addSubview(tableView!)
        tableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        tableView?.register(JYD_StoreListTableViewCell.self, forCellReuseIdentifier: "JYD_StoreListTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        storeListCell = tableView.dequeueReusableCell(withIdentifier: "JYD_StoreListTableViewCell", for: indexPath) as? JYD_StoreListTableViewCell
        if storeListCell == nil {
            storeListCell = JYD_StoreListTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "JYD_StoreListTableViewCell")
        }
        let storeInfo = storeInfolists![indexPath.section]
        storeListCell?.configureContent(title: "\(storeInfo.storeName ?? "")", time: "\(storeInfo.businessHours ?? "")", address: "\(storeInfo.storeAddress ?? "")", distance: "\(storeInfo.distance ?? "")")
        storeListCell?.pathTapClick = {
            self.pushPathListVC(storeInfo)
        }
        return storeListCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        let storeInfo = storeInfolists![indexPath.section]
        let storeDetailVC = JYD_StoreDetailViewController()
        storeDetailVC.storeID = storeInfo.storeId
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return APPTool.obtainDisplaySize(size: 85)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: _k_w, height: 8))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (storeInfolists?.count)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pushPathListVC(_ storeInfo:StoreListResult)  {
        
        guard (storeInfo != nil) else {
            return
        }
        
        let latStr = storeInfo.mapMarkLatitude! as NSString
        let lonStr = storeInfo.mapMarkLongitude! as NSString
        let storeCoor = CLLocationCoordinate2DMake(latStr.doubleValue, lonStr.doubleValue)
        let selectStoreVC = JYD_SelectPathViewController.init()
        selectStoreVC.startCoord = APPUtilityInfo.shareInstance.userCurrentLocation
        selectStoreVC.endCoord = storeCoor
        selectStoreVC.endLoactionName = storeInfo.storeName!
        self.navigationController?.pushViewController(selectStoreVC, animated: true)
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
