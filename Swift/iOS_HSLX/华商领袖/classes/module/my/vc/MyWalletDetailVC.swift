//
//  MyWalletDetailVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/27.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

/**
 * 我的钱包详情
 * @param <#name#> <#desc#>
 *
 */
class MyWalletDetailVC: BaseVC {

    @IBOutlet weak var segmentView: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包明细"
        self.view.addSubview(self.balanceTableView)
        self.balanceTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.segmentView.snp.bottom).offset(10)
        }
        self.view.addSubview(self.integralTableView)
        self.integralTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.segmentView.snp.bottom).offset(10)
        }
        self.balanceTableView.dataSource = self
        self.balanceTableView.delegate = self
        self.integralTableView.dataSource = self
        self.integralTableView.delegate = self
        self.integralTableView.mj_header.beginRefreshing()
        self.balanceTableView.mj_header.beginRefreshing()
        self.balanceTableView.loadDataFinished = {
            [weak self] (response, type) in
            if  type == 0 {
                let dict = response as! [String : Any]
                self?.balanceSecionOneSources[0]["income"] = "\(dict["yearTotal"] ?? "0")元"
                self?.balanceSecionOneSources[1]["income"] = "\(dict["yearBrokerageTotal"] ?? "0")元"
                self?.balanceSecionOneSources[2]["income"] = "\(dict["monthBrokerageTotal"] ?? "0")元"
            }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func segementChanged(_ sender: UISegmentedControl) {
        
        self.balanceTableView.isHidden = sender.selectedSegmentIndex == 1
        self.integralTableView.isHidden = sender.selectedSegmentIndex == 0
        
    }
    
    private lazy var balanceTableView: DYTableView<MyNetwork, MyWalletDetailModel> = {
        let view = DYTableView<MyNetwork, MyWalletDetailModel>()
        view.pageSize = 10
        view.loadDataCallback = {
            (page) in
            kNetworkDetailType = 1
            return MyNetwork.getMyBalanceOrIntegralDetail(page: page, size: 10)
        }
//        view.loadMoreDataCallback = {
//            (pageIndex) in
//            kNetworkDetailType = 1
//            return MyNetwork.getMyBalanceOrIntegralDetail(page: pageIndex, size: 10)
//        }
        view.listKey = "detailList"
        view.section = 1
        view.rowHeight = 60
        view.allowsSelection = false
        return view
    }()
    private lazy var integralTableView: DYTableView<MyNetwork, MyWalletDetailModel> = {
        let view = DYTableView<MyNetwork, MyWalletDetailModel>()
        view.pageSize = 10
        view.loadDataCallback = {
            (page) in
            kNetworkDetailType = 0
            return MyNetwork.getMyBalanceOrIntegralDetail(page: page, size: 5)
        }
//        view.loadMoreDataCallback = {
//            (pageIndex) in
//            kNetworkDetailType = 0
//            return MyNetwork.getMyBalanceOrIntegralDetail(page: pageIndex, size: 5)
//        }
        view.rowHeight = 60
        view.allowsSelection = false
        view.isHidden = true
        return view
    }()
    
    private var balanceSources:[MyWalletDetailModel] = []
    private var balancePage = 0
    private var integralPage = 0
    private var pageSize = 5
    
    private var integralSources:[MyWalletDetailModel] = []
    
    private var balanceSecionOneSources: [[String : String]] = {
        return [
            ["title":"本年度零钱收入","income":""],
            ["title":"本年度佣金收入","income":""],
            ["title":"本月佣金收入","income":""],
        ]
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyWalletDetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == self.balanceTableView ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && tableView == self.balanceTableView {
            return self.balanceSecionOneSources.count
        }
        return tableView == self.balanceTableView ? self.balanceTableView.dataSources.count : self.integralTableView.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.balanceTableView {
            var cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "section1")
            cell.textLabel?.textColor = kThemeTextColor
            if indexPath.section == 0 {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.textLabel?.text = self.balanceSecionOneSources[indexPath.row]["title"]
                
                cell.detailTextLabel?.text = self.balanceSecionOneSources[indexPath.row]["income"]
            } else {
                cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "section2")
                let typeDict = [0:"活动参与",1:"其他",2:"其他",3:"用户成为会员奖励",4:"分享活动佣金",5:"活动报名收入",6:"活动促成奖励",7:"活动推荐奖励",8:"其他",9:"其他",10:"提现扣除",11:"提现手续费"];
                let model = self.balanceTableView.dataSources[indexPath.row];
                cell.textLabel?.text = typeDict[model.type ?? 1];
                cell.detailTextLabel?.text = Date.getFormdateYMDHM(timeStamp: model.createTime ?? 0)
                let operateType = (model.operateType ?? 0) == 1 ? "-" : "+";
                let rightLabel = UILabel.init();
                rightLabel.text = "\(operateType)\(model.operateNumber ?? 0.0)";
                rightLabel.textColor = (model.operateType ?? 0) == 1 ? UIColor.red : UIColor.green;
                rightLabel.font = UIFont.systemFont(ofSize: 18)
                cell.accessoryView = rightLabel
                rightLabel.sizeToFit()
//                cell.textLabel?.text = self.balanceSources[indexPath.row]
                
            }
            return cell
        }
        
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        let typeDict = [0:"活动参与",1:"其他",2:"其他",3:"用户成为会员奖励",4:"分享活动佣金",5:"活动报名收入",6:"活动促成奖励",7:"活动推荐奖励",8:"其他",9:"其他",10:"提现扣除",11:"提现手续费"];
        let model = self.integralTableView.dataSources[indexPath.row];
        cell.textLabel?.text = typeDict[model.type ?? 1];
        cell.detailTextLabel?.text = Date.getFormdateYMDHM(timeStamp: model.createTime ?? 0)
        let operateType = (model.operateType ?? 0) == 1 ? "-" : "+";
        let rightLabel = UILabel.init();
        rightLabel.text = "\(operateType)\(model.operateNumber ?? 0.0)";
        rightLabel.textColor = (model.operateType ?? 0) == 1 ? UIColor.red : UIColor.green;
        rightLabel.font = UIFont.systemFont(ofSize: 18)
        cell.accessoryView = rightLabel
        rightLabel.sizeToFit()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}

