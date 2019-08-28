//
//  ActivityApplyListVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/17.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class ActivityApplyListVC: BaseVC {

    
    var activityID: String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "报名列表";
        
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.tableView.didSelectCellCallback = {
            [weak self] (indexPath, model) in
            
            let vc = MyInfoVC.init();
            vc.userid = (model as! NearbyPersonModel).userId;
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        
        self.tableView.beginLoadData();
        
        // Do any additional setup after loading the view.
    }
    
    
    private lazy var tableView: WNTableView = {
        let view = WNTableView()
        view.tableFooterView = UIView.init()
//        view.separatorColor = UIColor.clear
        view.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.loadDataCallback = {
            [weak self] (page, callback) in
            kNetworkActivityID = self?.activityID ?? "";
            return NetWorkRequestModel(network: ActivityNetwork.getActivityJoinList(page: page, size: 10), listKey: nil, modelType: NearbyPersonModel.self, finished: { (responses) in
                callback(responses ?? []);
            })
        }
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
