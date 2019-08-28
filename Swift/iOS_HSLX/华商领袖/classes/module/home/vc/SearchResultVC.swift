//
//  SearchResultVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/11.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh
import Moya
class SearchResultVC<Request : TargetType, Model: BaseModel, Cell: BaseCell>: BaseVC,UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate {
    
    var searchPlaceholder = "搜索"
//    var type = 1
    var pageIndex = 0
    var pageSize = 10
    var cellNib: String?
    var rowHeight:CGFloat = 0
    var networkTarget: Request?
    var searchTextChangedCallback: ((String) -> Request)?
    var selectedCellModelCallback: ((Model) -> Void)?
    /**
     * 加载更多的网络求情
     * @param Int pageIndex
     * @param string 关键字
     */
    var loadMoreDataCallback: ((Int, String) -> Request)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.searchBar
        self.searchBar.placeholder = self.searchPlaceholder
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.rowHeight = self.rowHeight
        self.searchBar.delegate = self
        self.loadData()
    }
    
    private lazy var searchBar: UISearchBar = {
        
        let search = UISearchBar.init()
        
        return search
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView.init()
        view.register(UINib.init(nibName: self.cellNib ?? "SearchListCell", bundle: nil), forCellReuseIdentifier: "cell")
        return view
    }()
    private var dataSources: [Model] = []
    
    private func loadData() {
       
        
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            self?.networkTarget = self?.searchTextChangedCallback!(self?.searchBar.text ?? " ")
            NetWorkRequest(target: (self?.networkTarget)!, finished: { (result) in
                self?.tableView.mj_header.endRefreshing()
                self?.dataSources.removeAll()
                switch result {
                    
                case let .successful(response):
                    let data = response as! [[String : Any]]
                    data.forEach({ (item) in
                    
                        self?.dataSources.append(Model.init(JSON: item)!)
                    })
                    if data.count > 0 {
                        self?.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self?.loadMoreData))
                    }
                    self!.tableView.reloadData()
                    if data.count < self?.pageSize ?? 5 && data.count > 0{
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    break
                    
                case let .failure(ErrMsg):
                    SVProgressHUD.showError(withStatus: ErrMsg)
                    
                    break
                }
                
            })
        }
    }
    
    
    @objc private func loadMoreData() {
        self.pageIndex += 1
        self.networkTarget = self.loadMoreDataCallback!(self.pageIndex, self.searchBar.text!)
        NetWorkRequest(target: networkTarget!, finished: { (result) in
            
            self.tableView.mj_footer.endRefreshing()
            switch result {
                
            case let .successful(response):
                let resultData = response as! Array<Dictionary<String,Any>>
                var indexes: [IndexPath] = []
                
                resultData.forEach({ (item) in
                    indexes.append(IndexPath.init(item: self.dataSources.count, section: 0))
                    self.dataSources.append(Model.init(JSON: item)!)
                })
                self.tableView.insertRows(at: indexes, with: UITableView.RowAnimation.none)
                if resultData.count < self.pageSize && resultData.count > 0{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                break
                
            case let .failure(ErrMsg):
                self.pageIndex -= 1
                SVProgressHUD.showError(withStatus: ErrMsg)
                
                break
            }
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        cell.model = self.dataSources[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.selectedCellModelCallback != nil {
            
            self.selectedCellModelCallback!(self.dataSources[indexPath.row])
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
//        if self.searchTextChangedCallback != nil {
//
//           self.networkTarget = self.searchTextChangedCallback!(searchBar.text!)
//
//        }
        self.tableView.mj_header.beginRefreshing()
        
    }

    
   
}


//extension SearchResultVC: UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate {
//
//
//}
