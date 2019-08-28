//
//  DetailMemberListVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh
class DetailMemberListVC: UIViewController {

    var groupID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "成员列表"
        self.setupSubview()
        // Do any additional setup after loading the view.
    }
    private func setupSubview() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    
    @objc private func loadData () {
        networkGroupID = self.groupID
        self.pageIndex = 0
        NetWorkRequest(target: HomeNetwork.getGroupDetailMemberList(pageSize: self.pageSize, pageIndex: self.pageIndex, role: 4)) { (result) in
            
            self.tableView.mj_header.endRefreshing();
            switch result {
                
            case .successful(let response):
                self.dataSources.removeAll()
                let dict = response as! [String : Any]
                let array = dict["memberList"] as! [[String:Any]]
                for item in array {
                    self.dataSources.append(GroupDetailMemberModel.init(JSON: item)!)
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
        NetWorkRequest(target: HomeNetwork.getGroupDetailMemberList(pageSize: self.pageSize, pageIndex: self.pageIndex, role: 4)) { (result) in
            
            self.tableView.mj_header.endRefreshing();
            switch result {
                
            case .successful(let response):
                let dict = response as! [String : Any]
                let array = dict["memberList"] as! [[String:Any]]
                var indexPathes: [IndexPath] = []
                for item in array {
                    indexPathes.append(IndexPath.init(row: self.dataSources.count, section: 0))
                    self.dataSources.append(GroupDetailMemberModel.init(JSON: item)!)
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
    
    private var dataSources: [GroupDetailMemberModel] = []
    private var pageIndex = 0
    private var pageSize = 10
    private lazy var tableView: UITableView = {
        
        let tableview = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableview.tableFooterView = UIView.init()
        tableview.rowHeight = 80
        return tableview
        
    }()
    
}


extension DetailMemberListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeFriendInfoCell
        cell.memberModel = self.dataSources[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
