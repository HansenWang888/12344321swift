//
//  GroupDynamicVC.swift
//  华商领袖
//
//  Created by abc on 2019/4/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh
private let glt_iphoneX: Bool = (UIScreen.main.bounds.height >= 812.0)
class GroupDynamicVC: BaseVC, LTTableViewProtocal {
    
    
    
    private var datasources: Array<HomeDynamicModel> = []
    private var page = 1
    private var heightDict: [Int : CGFloat] = [:]
    private lazy var tableView: UITableView = {
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - 64 - 24 - 34) : view.bounds.height  - 64
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width: view.bounds.width, height: H), self, self, nil)
        tableView.tableFooterView = UIView.init()
        tableView.register(UINib.init(nibName: "HomeListCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
extension GroupDynamicVC {
    
    fileprivate func reftreshData()  {
        
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            self!.page = 0
            
            NetWorkRequest(target: HomeNetwork.getGroupDynamics(size: 10, type: 0, page: self!.page, lat: LocationManager.shared.latitude!, lng: LocationManager.shared.longitude!), finished: { (result) in
                
                self?.tableView.mj_header.endRefreshing()
                self?.datasources.removeAll()
                self?.heightDict.removeAll()
                switch result {
                    
                case let .successful(response):
                    let data = response as! Array<Dictionary<String,Any>>
                    data.forEach({ (item) in
                        self?.datasources.append(HomeDynamicModel.init(JSON: item)!)
                    })
                    self?.calculateCellHeight()
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
        self.loadData()
    }
    
    @objc private func loadMoreData() {
        
        self.page += 1
       
        NetWorkRequest(target: HomeNetwork.getGroupDynamics(size: 10, type: 0, page: self.page, lat: LocationManager.shared.latitude!, lng: LocationManager.shared.longitude!)){ (result) in
            
            self.tableView.mj_footer.endRefreshing()
            switch result {
                
            case let .successful(response):
                let resultData = response as! Array<Dictionary<String,Any>>
                var indexes: [IndexPath] = []
                
                resultData.forEach({ (item) in
                    indexes.append(IndexPath.init(item: self.datasources.count, section: 0))
                    self.datasources.append(HomeDynamicModel.init(JSON: item)!)
                })
                self.calculateCellHeight()
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
        }

        
    }
    private func calculateCellHeight() {
//        DispatchQueue.global().async {
            let startIndex = self.heightDict.keys.count
            for index in startIndex ..< self.datasources.count {
                var cellHeight:CGFloat = 100 + 47
                let item = self.datasources[index]
                let textHeight = item.content?.getTextHeigh(font: UIFont.systemFont(ofSize: 15), width: self.view.width - 30) ?? 0
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
                cellHeight = textHeight + pictureHeight + cellHeight
                self.heightDict[index] = cellHeight
//            }
        }
    }
    
}

extension GroupDynamicVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeListCell
        
        cell.model = self.datasources[indexPath.item]

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DynamicDetailVC.init();
        vc.model = self.datasources[indexPath.row];
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightDict[indexPath.item] ?? 100
    }
}

