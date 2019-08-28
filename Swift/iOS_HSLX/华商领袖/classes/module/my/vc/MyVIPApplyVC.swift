//
//  MyVIPApplyVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class MyVIPApplyVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    private var dataSources: [[String : Any]] = []
    private var model: MyVipApplyModel = MyVipApplyModel.init(JSON: [:])!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员中心"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "转发"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBtnClick))
        self.tableView.tableHeaderView = MyVipHeaderView.initHeaderView()
        self.tableView.separatorColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.loadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 275)

    }

    
    @objc func rightBtnClick() {
        //分享
        
        
    }
    private func loadData() {
        NetWorkRequest(target: MyNetwork.getVIPApplyInfo) { (result) in
            
            switch result {
                
            case .successful(let response):
                
                let resultData = (response as! [[String : Any]]).first
                let view = self.tableView.tableHeaderView as! MyVipHeaderView
                self.model = MyVipApplyModel.init(JSON: resultData!)!
                view.titleLabel.text = self.model.name
                view.subTitleLabel.text = self.model.englishName
                view.priceLabel.text = "￥ \(self.model.price ?? 0)"
                self.dataSources = self.model.privilegeList!
                self.tableView.reloadData()
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
    }
    
    
    
    @IBAction func applyBtnClick(_ sender: Any) {
        
        let model = PayModel.init();
        model.giftBagId = 0;
        model.price = "600.00";
        model.productId = "1";
        model.type = 1;
        model.sid = 0;
        let vc = MyPaymentVC.init(model);
        self.navigationController?.pushViewController(vc, animated: true);
        
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


extension MyVIPApplyVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if indexPath.section == 0 {
            cell.textLabel?.text = self.model.description
            cell.textLabel?.textColor = UIColor.lightGray
        } else {
            
            let content = self.dataSources[indexPath.row]["content"] as? String ?? ""
            cell.imageView?.image = UIImage.init(named: "VIPList")
            cell.textLabel?.text = content
            cell.textLabel?.textColor = UIColor.HWColorWithHexString(hex: "#333333")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init()
        let array = ["会员说明","会员特权"]
        label.text = "    " + array[section]
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.HWColorWithHexString(hex: "#333333")
        label.backgroundColor = UIColor.HWColorWithHexString(hex: "#c4cfee")
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
