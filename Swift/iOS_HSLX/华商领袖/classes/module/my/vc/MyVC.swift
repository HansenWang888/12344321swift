//
//  MyVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MyVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = MyheaderView()
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 110)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "设置"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingBtnClick))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.tableView.rowHeight = 50
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .groupTableViewBackground
    }
    
    func updateUserInfo()  {
        let view = self.tableView.tableHeaderView as! MyheaderView
        
        view.nameBtn.setTitle(LoginManager.manager.user?.nickName!, for: UIControl.State.normal)
        view.imgView.kf.setImage(with: URL.init(string: (LoginManager.manager.user?.headUrl!)!))
        view.subTitle.text = "\(LoginManager.manager.user?.companyName ?? "")\(LoginManager.manager.user?.postName ?? "")"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserInfo()

    }
    
    @objc func settingBtnClick() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(MySettingVC(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    lazy var dataSources: Array<Array<Dictionary<String, String>>> = [{
        return [
            ["title":"会员中心","icon":"icon_friends","detailText":LoginManager.manager.user?.vipLevel == 0 ? "尚未成为会员" : "银牌会员"],
            ["title":"我的钱包","icon":"icon_friends","detailText":"0"],
//            ["title":"我的订单","icon":"icon_friends","detailText":""],
            ["title":"推荐有奖","icon":"icon_friends","detailText":"影响力 0"],
            ["title":"朋友动态","icon":"icon_friends","detailText":""],
            ["title":"活动管理","icon":"icon_friends","detailText":""],
//            ["title":"商城管理","icon":"icon_friends","detailText":""]
        ]
        }()]
}


extension MyVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        }
        let dict = self.dataSources[indexPath.section][indexPath.row]
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell?.imageView?.image = UIImage.init(named: dict["icon"]!)
        cell?.textLabel?.text = dict["title"]
        cell?.detailTextLabel?.textColor = UIColor.HWColorWithHexString(hex: "#FF6B2D")
        cell?.detailTextLabel?.text = dict["detailText"]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc : UIViewController = UIViewController()
        vc.view.backgroundColor = UIColor.white
        
        switch indexPath.item {
        case 0:
            if LoginManager.manager.user?.vipLevel == 1 {
                SVProgressHUD.showInfo(withStatus: "您已是会员！")
                return
            }
            vc = MyVIPApplyVC()
            break
        case 1:
            
            vc = MyWallet()
            
            break
        case 2:
            vc = MyRecommendVC.init();
            break
        case 3:
            vc = MyFriendDynamicsVC.init();
            break
            
        case 4:
            vc = MyActivityVC.init();
            break
            
        default:
            break
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    
}
