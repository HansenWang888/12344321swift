//
//  MyFriendDynamicsVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/22.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class MyFriendDynamicsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView);
        self.title = "朋友动态";
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.tableView.beginLoadData();
        // Do any additional setup after loading the view.
    }
    

    
    private lazy var tableView: WNTableView = {
        let view = WNTableView()
        view.tableFooterView = UIView.init();
        view.loadDataCallback = {
            (page, callback) in
            
            NetWorkRequestModel(network: MyNetwork.getMyFriendDynamics(page: page, size: 10), listKey: nil, modelType: HomeDynamicModel.self, finished: { (responses) in
                callback(responses ?? []);
            })
        }
        view.dataSource = self;
        view.delegate = self;
        view.register(UINib.init(nibName: "HomeListCell", bundle: nil), forCellReuseIdentifier: "cell");
        return view;
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

extension MyFriendDynamicsVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataSources.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeListCell;
        cell.type = .nearbyDynamic;
        cell.model = self.tableView.dataSources[indexPath.row] as? HomeDynamicModel;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let model = self.tableView.dataSources[indexPath.row] as! HomeDynamicModel;
        let vc = DynamicDetailVC.init();
        vc.model = model;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.tableView.dataSources[indexPath.row] as! HomeDynamicModel;
        let height = self.tableView.heightCache[indexPath.row] ?? model.calculateCellHeight() + 50;
        self.tableView.heightCache[indexPath.row] = height;
        return height;
    }
    
}
