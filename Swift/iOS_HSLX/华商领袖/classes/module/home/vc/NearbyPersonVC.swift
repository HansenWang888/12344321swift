//
//  NearbyPersonVC.swift
//  华商领袖
//
//  Created by abc on 2019/4/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

private let glt_iphoneX: Bool = (UIScreen.main.bounds.height >= 812.0)
class NearbyPersonVC: BaseVC, LTTableViewProtocal {
    
    private var datasources: Array<NearbyPersonModel> = []
    private var page = 1
    private lazy var tableView: UITableView = {
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - 64 - 24 - 34) : view.bounds.height  - 64
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width: view.bounds.width, height: H), self, self, nil)
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        glt_scrollView = tableView
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    @objc func loadData() {
        self.tableView.mj_header.beginRefreshing()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension NearbyPersonVC {
    
    fileprivate func reftreshData()  {
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            self!.page = 0
            NetWorkRequestModel(network: HomeNetwork.getNearbyPeoples(size: 10, page: self!.page, lat: LocationManager.shared.latitude!, lng: LocationManager.shared.longitude!), listKey: nil, modelType: NearbyPersonModel.self, finished: { (resultData) in
                
                self?.tableView.mj_header.endRefreshing();
                if resultData != nil {
                    self?.datasources.removeAll()
                    self?.datasources.append(contentsOf: resultData!)
                    if resultData!.count > 0 {
                        self?.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self?.loadMoreData))
                    }
                    self?.tableView.reloadData()
                    if resultData!.count < 10 && resultData!.count > 0  {
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                
            })
           
        }
        self.loadData()
    }
    
    @objc private func loadMoreData() {
        
        self.page += 1
        NetWorkRequestModel(network: HomeNetwork.getNearbyPeoples(size: 10, page: self.page, lat: LocationManager.shared.latitude!, lng: LocationManager.shared.longitude!), listKey: nil, modelType: NearbyPersonModel.self) { (resultData) in
            
            self.tableView.mj_footer.endRefreshing()
            if resultData != nil {
                var indexes: [IndexPath] = []
                resultData!.forEach({ (item) in
                    indexes.append(IndexPath.init(item: self.datasources.count, section: 0))
                    self.datasources.append(item)
                })
                self.tableView.insertRows(at: indexes, with: UITableView.RowAnimation.none)
                if resultData!.count < 10 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            } else {
                self.page -= 1;
            }
        }
       
        
    }
    
}

extension NearbyPersonVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeFriendInfoCell
        cell.model = self.datasources[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("点击了第\(indexPath.row + 1)行")
        let model = self.datasources[indexPath.row]
        let vc = MyInfoVC()
        vc.userid = model.userId;
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

