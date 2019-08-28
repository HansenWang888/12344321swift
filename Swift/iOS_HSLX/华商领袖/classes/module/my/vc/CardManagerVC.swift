//
//  CardManagerVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/28.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

class CardManagerVC: BaseVC {
    
    private var dataSources: Array<MyBankCardModel> = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "银行卡信息"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib.init(nibName: "CardManagerCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.register(UINib.init(nibName: "CardManagerCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 120
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableView.mj_header.beginRefreshing()
        self.tableView.tableFooterView = UIView.init()
        self.bottomView.addRounded(radius: 5)
        self.bottomView.addRoundedOrShadow(radius: 5)
        self.tableView.separatorColor = UIColor.clear
        self.bottomView.addBorder(width: 1.0, borderColor: .lightGray)
        self.tableView.backgroundColor = .groupTableViewBackground
        self.view.backgroundColor = .groupTableViewBackground
        // Do any additional setup after loading the view.
    }

    @objc private func loadData() {
    
        NetWorkRequest(target: MyNetwork.getMyBankCards) { (result) in
            self.tableView.mj_header.endRefreshing()
            switch result {
                
            case .successful(let response):
                self.dataSources.removeAll()
                let array = response as! [[String : Any]]
                for item in array {
                    self.dataSources.append(MyBankCardModel.init(JSON: item)!)
                }
                self.tableView.reloadData()
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
    
    
    }
    
    @IBAction func addCardClick(_ sender: Any) {
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CardManagerVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardManagerCell
        cell.contentView.backgroundColor = .groupTableViewBackground
       cell.model = self.dataSources[indexPath.row]
        
        return cell
    }
    
    
}
