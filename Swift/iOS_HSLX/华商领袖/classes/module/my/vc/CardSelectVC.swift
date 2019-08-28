//
//  CardSelectVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/28.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh
class CardSelectVC: BaseVC {

    
    var selectedBankCardCallback: ((MyBankCardModel) -> Void)?
    private var dataSources: Array<MyBankCardModel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择银行卡"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "新增银行卡", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarBtnClick))
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
           
            [weak self]  in
            NetWorkRequest(target: MyNetwork.getMyBankCards, finished: { (result) in
                self?.tableView.mj_header.endRefreshing()
                switch result {
                    
                case .successful(let response):
                    self?.dataSources.removeAll()
                    let array = response as! [[String : Any]]
                    for item in array {
                        self?.dataSources.append(MyBankCardModel.init(JSON: item)!)
                    }
                    self?.tableView.reloadData()
                    break
                    
                case .failure(let errmsg) :
                    SVProgressHUD.showError(withStatus: errmsg)
                    break
                    
                }
            })
        })
        self.tableView.mj_header.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc private func rightBarBtnClick() {
        
        if LoginManager.manager.user?.isRealName != 2 {
            
            self.showAuthrizeVC {
                [weak self] in
                self?.tableView.mj_header.beginRefreshing()
            }
            
        } else {
            
            let vc = MyAddBankCardVC.init()
            
            vc.finishedCallback = {
                [weak self] in
                self?.tableView.mj_header.beginRefreshing()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    
    }

    lazy var tableView: UITableView = {
        
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.rowHeight = 55
        view.tableFooterView = UIView.init()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
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


extension CardSelectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        let model = self.dataSources[indexPath.row]
        cell!.textLabel?.text = model.bank
//        cell?.textLabel?.textColor = kThemeColor
        cell?.detailTextLabel?.textColor = UIColor.gray
        let bankNum = model.bankNo
        cell!.detailTextLabel?.text = "\((bankNum?.substring(fromIndex: bankNum!.length - 4)) ?? "0")银行尾号\(model.cardType ?? "借记卡")"
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.selectedBankCardCallback != nil {
            
            self.navigationController?.popViewController(animated: true)
            self.selectedBankCardCallback!(self.dataSources[indexPath.row])
        }
        
    }
    
}
