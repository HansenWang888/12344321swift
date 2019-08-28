//
//  WNTableView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/5.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

class WNTableView: UITableView {

    /**
     * 辨别属于什么类型， 有多个tableview时使用
     *
     */
    var type: Any?
    
    var pageIndex = 0;
    /**
     * 当设置size== 0时 不能上拉加载
     *
     */
    var pageSize = 10;
    ///上下拉刷新 获取网络请求 必须
    var loadDataCallback: ((_ pageIndex: Int, @escaping ([AnyObject]) -> Void) -> Void)?
    ///点击某个cell
    var didSelectCellCallback: ((_ indexPath: IndexPath, _ model: AnyObject) -> Void)?
    ///翻页时要刷新的那组数据
    var section: Int = 0
    
    var dataSources: [AnyObject] = []
    
    var heightCache: [Int: CGFloat] = [:]
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableFooterView = UIView.init()
        self.dataSource = self;
        self.delegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func beginLoadData() {
        self.mj_header.beginRefreshing();
    }
    
    @objc private func loadData() {
       
        self.pageIndex = 0
        if self.loadDataCallback != nil {
            self.loadDataCallback!(0, {
                [weak self] (response) in
                self?.handleDownData(responses: response)
            })
        }
    }
    @objc private func loadMoreData () {
        self.pageIndex += 1;
        if self.loadDataCallback != nil {
            self.loadDataCallback!(pageIndex,{
                [weak self] (responses) in
                self?.handleUpDragData(responses: responses)
            })
        }
    }
    private func handleDownData (responses : [AnyObject]) {
        self.mj_header.endRefreshing()
        self.dataSources.removeAll()
        self.dataSources.append(contentsOf: responses)
        self.reloadData()
        if responses.count > 0  && responses.count == self.pageSize {
            self.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
        }
        if responses.count < self.pageSize && self.mj_footer !== nil {
            self.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    private func handleUpDragData(responses: [AnyObject]) {
        self.mj_footer.endRefreshing()
        var indexes: [IndexPath] = []
        for item in responses {
            indexes.append(IndexPath.init(row: self.dataSources.count, section: self.section))
            self.dataSources.append(item)
        }
        self.insertRows(at: indexes, with: UITableView.RowAnimation.none)
        if responses.count < self.pageSize {
            self.mj_footer.endRefreshingWithNoMoreData()
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


extension WNTableView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BaseCell
        cell?.model = self.dataSources[indexPath.row];
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        if self.didSelectCellCallback != nil {
            self.didSelectCellCallback!(indexPath,self.dataSources[indexPath.row]);
        }
    }
    
    
}
