//
//  MyActivityVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class MyActivityVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.view.addSubview(self.tableViewJoined);
        self.tableViewJoined.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        self.tableView.beginLoadData();
        self.tableViewJoined.beginLoadData();
        self.sliderView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth * 0.5, height: 44);
        self.navigationItem.titleView = self.sliderView;
        self.sliderView.selectIndexBlock = {
            [weak self] (index) in
            self?.tableView.isHidden = index == 1;
            self?.tableViewJoined.isHidden = index == 0;
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //titleView 在上一个页面回来的时候size会变成0

    }
    private lazy var tableView: WNTableView = {
        let view = WNTableView()
        view.tableFooterView = UIView.init();
        view.loadDataCallback = {
            (page, callback) in
            
            NetWorkRequestModel(network: ActivityNetwork.getMyActivities(page: page, size: 10, userId: LoginManager.manager.user?.userId ?? 0), listKey: nil, modelType: ActivityGroupListModel.self, finished: { (responses) in
                callback(responses ?? []);
            })
        }
        view.dataSource = self;
        view.delegate = self;
        view.register(UINib.init(nibName: "MyActivityListCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.rowHeight = 120;
        view.separatorColor = UIColor.clear;
        return view;
    }()
    private lazy var tableViewJoined: WNTableView = {
        let view = WNTableView()
        view.tableFooterView = UIView.init();
        view.loadDataCallback = {
            (page, callback) in
            
            NetWorkRequestModel(network: ActivityNetwork.getMyJoinedActivities(page: page, size: 10), listKey: nil, modelType: ActivityGroupListModel.self, finished: { (responses) in
                callback(responses ?? []);
            })
        }
        view.dataSource = self;
        view.delegate = self;
        view.register(UINib.init(nibName: "MyActivityListCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.rowHeight = 120;
        view.separatorColor = UIColor.clear;
        view.isHidden = true;
        return view;
    }()
    
    private lazy var sliderView: DYSliderHeadView = {
        let view = DYSliderHeadView.init(titles: ["我发布的活动","我参与的活动"]);
        view.hideBottomLine();
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
extension MyActivityVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.tableView.dataSources.count;

        }
        return self.tableViewJoined.dataSources.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyActivityListCell;
        
        if tableView == self.tableView {
            cell.model = self.tableView.dataSources[indexPath.row] as? ActivityGroupListModel;

        } else {

            cell.model = self.tableViewJoined.dataSources[indexPath.row] as? ActivityGroupListModel;
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        var model = self.tableView.dataSources[indexPath.row] as! ActivityGroupListModel;
        if tableView == self.tableViewJoined {
            model = self.tableViewJoined.dataSources[indexPath.row] as! ActivityGroupListModel;
            let vc = ActivityDetailVC.init();
            vc.activityID = model.id;
            self.navigationController?.pushViewController(vc, animated: true);
        } else {
            let vc = MyActivityManagerVC.init();
            vc.model = model;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
        
    }
   
    
}
