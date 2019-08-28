//
//  GroupActivityVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

class GroupActivityVC: BaseVC,LTTableViewProtocal {

    /// 0 : 社群  1： 个人
    var type: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubview()
        
        // Do any additional setup after loading the view.
    }
    private func setupSubview() {
        self.view.addSubview(tableView)
        glt_scrollView = tableView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    
    @objc private func loadData () {
        self.pageIndex = 0
        NetWorkRequest(target: ActivityNetwork.getGroupActivityList(type: self.type, pageSize: self.pageSize, pageIndex: self.pageIndex)) { (result) in
            
            self.tableView.mj_header.endRefreshing();
            switch result {
                
            case .successful(let response):
                self.dataSources.removeAll()
                let array = response as! [[String:Any]]
                for item in array {
                    self.dataSources.append(ActivityGroupListModel.init(JSON: item)!)
                }
                
                if self.dataSources.count >= self.pageSize {
                    self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
                }
                
                if self.dataSources.count < self.pageSize && self.pageIndex > 0 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.tableView.reloadData()
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
        
        
    }
    @objc private func loadMoreData () {
        self.pageIndex += 1
        NetWorkRequest(target: ActivityNetwork.getGroupActivityList(type: self.type, pageSize: self.pageSize, pageIndex: self.pageIndex)) { (result) in
            
            self.tableView.mj_header.endRefreshing();
            switch result {
                
            case .successful(let response):
                let array = response as! [[String:Any]]
                var indexPathes: [IndexPath] = []
                for item in array {
                    indexPathes.append(IndexPath.init(row: self.dataSources.count, section: 0))
                    self.dataSources.append(ActivityGroupListModel.init(JSON: item)!)
                }
                if array.count < self.pageSize {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.tableView.insertRows(at: indexPathes, with: UITableView.RowAnimation.none)
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
    }
    
    private var dataSources: [ActivityGroupListModel] = []
    private var pageIndex = 0
    private var pageSize = 10
//    private lazy var tableView: UITableView = {
//
//        let tableview = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
//        tableview.register(UINib.init(nibName: "ActivityGroupListCell", bundle: nil), forCellReuseIdentifier: "cell")
//        tableview.tableFooterView = UIView.init()
//        tableview.estimatedRowHeight = 225
//        return tableview
//
//    }()
    private lazy var tableView: UITableView = {
        let H: CGFloat = kiPhoneX ? (view.bounds.height - 64 - 24 - 34) : view.bounds.height  - 64
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width: view.bounds.width, height: H), self, self, nil)
        tableView.tableFooterView = UIView.init()
        tableView.register(UINib.init(nibName: "ActivityGroupListCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 280
        tableView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)

        return tableView
    }()
}


extension GroupActivityVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityGroupListCell
        cell.model = self.dataSources[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ActivityDetailVC.init()
        
        vc.activityID = self.dataSources[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
