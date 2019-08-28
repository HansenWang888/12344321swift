//
//  DetailDynamicListVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh
class DetailDynamicListVC: UIViewController {

    
    
    var groupID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "动态列表"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "新增动态", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addDynamic))
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

    @objc private func addDynamic () {
        
        
        
    }
    
    
    @objc private func loadData () {
        networkGroupID = self.groupID
        self.pageIndex = 0
        NetWorkRequest(target: HomeNetwork.getGroupDetailDynamicList(pageSize: self.pageSize, pageIndex: self.pageIndex)) { (result) in
            
            self.tableView.mj_header.endRefreshing();
            switch result {
                
            case .successful(let response):
                self.dataSources.removeAll()
                self.heightDict.removeAll()
                let array = response as! [[String : Any]]
                for item in array {
                    self.dataSources.append(GroupDetailDynaicModel.init(JSON: item)!)
                }
                
                if self.dataSources.count >= self.pageSize {
                    self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
                }
                
                if self.dataSources.count < self.pageSize && self.pageIndex > 0 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.calculateCellHeight()
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
        NetWorkRequest(target: HomeNetwork.getGroupDetailDynamicList(pageSize: self.pageSize, pageIndex: self.pageIndex)) { (result) in
            
            self.tableView.mj_header.endRefreshing();
            switch result {
                
            case .successful(let response):
                let array = response as! [[String : Any]]
                var indexPathes: [IndexPath] = []
                for item in array {
                    indexPathes.append(IndexPath.init(row: self.dataSources.count, section: 0))
                    self.dataSources.append(GroupDetailDynaicModel.init(JSON: item)!)
                }
                if array.count < self.pageSize {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.calculateCellHeight()
                self.tableView.insertRows(at: indexPathes, with: UITableView.RowAnimation.none)
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
    }
    private func calculateCellHeight() {
        //        DispatchQueue.global().async {
        let startIndex = self.heightDict.keys.count
        for index in startIndex ..< self.dataSources.count {
            var cellHeight:CGFloat = 50
            let item = self.dataSources[index]
            let titleTextHeight = item.title?.getTextHeigh(font: UIFont.systemFont(ofSize: 15), width: self.view.width - 30) ?? 0
            let textHeight = item.content?.getTextHeigh(font: UIFont.systemFont(ofSize: 12), width: self.view.width - 30) ?? 0
            var pictureHeight: CGFloat = 0
            var array: [String] = item.picture?.components(separatedBy: ",") ?? []
            if array.last?.count == 0 {
                array.removeLast()
            }
            if array.count > 0 {
                let pictureWH = (self.view.width - 30 - 10) / 3
                let row = CGFloat(array.count) / 3
                switch row{
                case 0...1:
                    pictureHeight = pictureWH
                    break
                case 1...2:
                    pictureHeight = pictureWH * 2 + 5
                    break
                case 2...3:
                    pictureHeight = pictureWH * 3 + 10
                    break
                default:
                    pictureHeight = 0
                }
                
            }
            cellHeight = textHeight + pictureHeight + cellHeight + titleTextHeight
            self.heightDict[index] = cellHeight
            //            }
        }
    }
    private var dataSources: [GroupDetailDynaicModel] = []
    private var pageIndex = 0
    private var pageSize = 10
    private var heightDict: [Int: CGFloat] = [:]
    private lazy var tableView: UITableView = {
        
        let tableview = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.register(UINib.init(nibName: "GroupDetailDynamicCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableview.tableFooterView = UIView.init()
        tableview.rowHeight = 80
        return tableview
        
    }()

}


extension DetailDynamicListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupDetailDynamicCell
        cell.model = self.dataSources[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightDict[indexPath.row] ?? 100
    }
}
