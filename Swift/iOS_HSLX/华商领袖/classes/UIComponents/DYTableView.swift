//
//  DYTableView.swift
//  华商领袖
//
//  Created by hansen on 2019/4/28.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh
import Moya



/*暂时只支持单组列表*/
class DYTableView<Request: TargetType, Model: BaseModel>: UITableView {

    
    
    var pageIndex = 0;
    /**
     * 当设置size== 0时 不能上拉加载
     *
     */
    var pageSize = 10;
    ///数据中所对应的数组key
    var listKey: String?
    ///上下拉刷新 获取网络请求 必须
    var loadDataCallback: ((_ pageIndex: Int) -> Request)?
   
    ///翻页时要刷新的那组数据
    var section: Int = 0
    //接口请求成功后的回调原始数据 type 0 = 下拉加载 1 = 上拉加载
    var loadDataFinished: ((_ response : Any, _ type: Int) -> Void)?
    
    var dataSources: [Model] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableFooterView = UIView.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func loadData() {
        guard let networkType = self.loadDataCallback?(0) else {
            debugPrint("No load request!!!")
            return
        }
        self.pageIndex = 0
        NetWorkRequest(target: networkType) { (result) in
        
            self.mj_header.endRefreshing()
            switch result {
            case .successful(let response):
                
                self.loadDataFinished?(response, 0)
                self.dataSources.removeAll()
                var array: [[String : Any]]? = nil
                if (self.listKey?.count ?? 0) > 0 {
                    //使用这个key取相对应的数据
                    guard let resultArray = (response as! [String : Any])[self.listKey!] as? [[String : Any]] else {
                        return
                    }
                    array = resultArray
                } else {
                    guard let resultArray = response as? [[String : Any]] else {
                        return
                    }
                    array = resultArray
                }
                
                for item in array! {
                    self.dataSources.append(Model.init(JSON: item)!)
                }
                self.reloadData()
                if array!.count > 0  && self.pageSize > 0{
                    self.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
                }
                if array!.count < self.pageSize && self.mj_footer !== nil {
                    self.mj_footer.endRefreshingWithNoMoreData()
                }
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
            
        }
        
    }
    
    @objc private func loadMoreData () {
        self.pageIndex += 1;
        guard let networkType = self.loadDataCallback?(self.pageIndex) else {
            debugPrint("No load more  request!!!")
            return
        }
        NetWorkRequest(target: networkType) { (result) in
            self.mj_footer.endRefreshing()
            switch result {
            case .successful(let response):
                self.loadDataFinished?(response, 1)
                var array: [[String : Any]]? = nil
                if (self.listKey?.count ?? 0) > 0 {
                    //使用这个key取相对应的数据
                    guard let resultArray = (response as! [String : Any])[self.listKey!] as? [[String : Any]] else {
                        return
                    }
                    array = resultArray
                } else {
                    guard let resultArray = response as? [[String : Any]] else {
                        return
                    }
                    array = resultArray
                }
                var indexes: [IndexPath] = []
                for item in array! {
                    indexes.append(IndexPath.init(row: self.dataSources.count, section: self.section))
                    self.dataSources.append(Model.init(JSON: item)!)
                }
                self.insertRows(at: indexes, with: UITableView.RowAnimation.none)
                if array!.count < self.pageSize {
                    self.mj_footer.endRefreshingWithNoMoreData()
                }
                break
            case .failure(let errmsg) :
                
                SVProgressHUD.showError(withStatus: errmsg)
                break
            }
        }
    }
    
    deinit {
        self.loadDataCallback = nil
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}



