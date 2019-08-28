//
//  SearchListVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/11.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

enum SearchListShowType {
    //社群列表
    case nearbyGroupType(title: String, searchPlaceholder: String, rightBarTitle: String)
    //华商领袖
    case HSLXType(title: String, searchPlaceholder: String, rightBarTitle: String)
    //商协会
    case businessAssociation(title: String, searchPlaceholder: String, rightBarTitle: String)
}


class SearchListVC: BaseVC {
    
    var showType: SearchListShowType?
    private var page = 0
    
    required init(showType: SearchListShowType) {
        super.init(nibName: nil, bundle: nil)
        self.showType = showType
        switch showType {
            
        case .nearbyGroupType(let title, let searchPlaceholder, let rightBarTitle):
            self.initialSubViewParameters(title: title, searchPlaceholder: searchPlaceholder, rightBarTitle: rightBarTitle)
            break
            
        case .HSLXType(let title, let searchPlaceholder, let rightBarTitle):
            self.initialSubViewParameters(title: title, searchPlaceholder: searchPlaceholder, rightBarTitle: rightBarTitle)

            break
        case .businessAssociation(let title, let searchPlaceholder, let rightBarTitle):
            self.initialSubViewParameters(title: title, searchPlaceholder: searchPlaceholder, rightBarTitle: rightBarTitle)
            break
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.tableHeaderView = self.searchBar
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 60)
        self.loadData()
    }
    
    private func initialSubViewParameters(title: String, searchPlaceholder: String, rightBarTitle: String) {
        
        self.title = title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: rightBarTitle, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarBtnClick))
        self.searchBar.placeholder = searchPlaceholder
    }
    
    @objc func rightBarBtnClick() {
        
        switch self.showType {
        case .nearbyGroupType?:
            if LoginManager.manager.user?.isRealName == 2 {
                let vc = CreateGroupVC.init()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showAuthrizeVC(nil)
            }
            
            
            break
        case SearchListShowType.HSLXType?:
            
            let view = DYApplyPromtView.show()
            view.confirmBtnClickBlock = { [weak self]  in
                if LoginManager.manager.user?.isRealName == 2 {
                    let vc = UnionOriginatorApplyVC.init()
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self?.showAuthrizeVC(nil)
                }
                
            }
            break
        case SearchListShowType.businessAssociation?:
            let alertVC = UIAlertController.initAlertCustomVC(message: "商协会板块仅对已在民政局注册的商会或协会免费开发，请谨慎申请！", confirmTitle: "立即申请") { (_) in
                if LoginManager.manager.user?.isRealName == 2 {
                    let vc = ApplyAssociationVC.init()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showAuthrizeVC(nil)
                }
            }
            self.present(alertVC, animated: true, completion: nil)
            
            break
        case .none:
            break
        }
        
    }
    
    private lazy var tableView: UITableView = {
        
        let tableview = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.register(UINib.init(nibName: "SearchListCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableview.tableFooterView = UIView.init()
        tableview.rowHeight = 80
        return tableview
        
    }()
    
    private lazy var searchBar: UISearchBar = {
        
        let search = UISearchBar.init()
        search.backgroundColor = UIColor.groupTableViewBackground
        
        return search
        
    }()
    
    private var dataSources: [SearchLishtModel] = []

}


extension SearchListVC {
    
    private func loadData() {
        
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
        
            self!.page = 0
            
            switch self?.showType {
                
            case .nearbyGroupType?:
                groupInfosType = 1
                break
                
            case .HSLXType?:
                groupInfosType = 3
                break
            case .businessAssociation?:
                groupInfosType = 2
                break
                
            case .none:
                break
            }
            NetWorkRequest(target: HomeNetwork.getHomeGroupInfoes(size: 10, page: self?.page ?? 0, lat: LocationManager.shared.latitude ?? 0.0, lng: LocationManager.shared.longitude ?? 0.0), finished: { (result) in
                self?.tableView.mj_header.endRefreshing()
                self?.dataSources.removeAll()
                switch result {
                    
                case let .successful(response):
                    let data = response as! Array<Dictionary<String,Any>>
                    data.forEach({ (item) in
                        self?.dataSources.append(SearchLishtModel.init(JSON: item)!)
                    })
                    if data.count > 0 {
                        self?.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self?.loadMoreData))
                    }
                    self!.tableView.reloadData()
                    if data.count < 10 && data.count > 0{
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    break
                    
                case let .failure(ErrMsg):
                    SVProgressHUD.showError(withStatus: ErrMsg)
                    
                    break
                }
                
            })
        }
        self.tableView.mj_header.beginRefreshing()
    }
    
    
    @objc private func loadMoreData() {
        
        self.page += 1
        switch self.showType {
            
        case .nearbyGroupType?:
            groupInfosType = 1
            break
            
        case .HSLXType?:
            groupInfosType = 3
            break
        case .businessAssociation?:
            groupInfosType = 2
            break
            
        case .none:
            break
        }
        NetWorkRequest(target: HomeNetwork.getHomeGroupInfoes(size: 10, page: self.page, lat: LocationManager.shared.latitude ?? 0.0, lng: LocationManager.shared.longitude ?? 0.0), finished: { (result) in

            self.tableView.mj_footer.endRefreshing()
            switch result {
                
            case let .successful(response):
                let resultData = response as! Array<Dictionary<String,Any>>
                var indexes: [IndexPath] = []
                
                resultData.forEach({ (item) in
                    indexes.append(IndexPath.init(item: self.dataSources.count, section: 0))
                    self.dataSources.append(SearchLishtModel.init(JSON: item)!)
                })
                self.tableView.insertRows(at: indexes, with: UITableView.RowAnimation.none)
                if resultData.count < 10 && resultData.count > 0{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                break
                
            case let .failure(ErrMsg):
                self.page -= 1
                SVProgressHUD.showError(withStatus: ErrMsg)
                
                break
            }
        })
        
    }
    
}

extension SearchListVC : UITableViewDataSource ,UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchListCell
        cell.model = self.dataSources[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataSources[indexPath.row]
        let vc = GroupDetailVC.init()
        vc.garoupId = model.groupId
        switch self.showType {
            
        case .nearbyGroupType?:
            vc.title = "社群详情"
            break
            
        case .HSLXType?:
            vc.title = "华商领袖俱乐部详情"
            break
        case .businessAssociation?:
            vc.title = "商协会详情"
            break
            
        case .none:
            break
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        let vc = SearchResultVC<HomeNetwork,SearchLishtModel,SearchListCell>.init()
        vc.searchPlaceholder = searchBar.placeholder ?? "搜索"
        vc.pageIndex = 0
        vc.pageSize = 10
        vc.cellNib = "SearchListCell"
        vc.rowHeight = 80
        
        vc.searchTextChangedCallback = {
            (text) in
            return HomeNetwork.searchGroupInfo(authState: 2, size: 10, page: 0, type: groupInfosType, key: text)
        }
        vc.loadMoreDataCallback = {
            (pageIndex, text) in
            return HomeNetwork.searchGroupInfo(authState: 2, size: 10, page: pageIndex, type: groupInfosType, key: text)

        }
        vc.selectedCellModelCallback = {
            [weak self] (model) in
            
            let vc = GroupDetailVC.init()
            vc.garoupId = model.groupId
            switch self?.showType {
                
            case .nearbyGroupType?:
                vc.title = "社群详情"
                break
                
            case .HSLXType?:
                vc.title = "华商领袖俱乐部详情"
                break
            case .businessAssociation?:
                vc.title = "商协会详情"
                break
                
            case .none:
                break
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        return false
    }
    
}
