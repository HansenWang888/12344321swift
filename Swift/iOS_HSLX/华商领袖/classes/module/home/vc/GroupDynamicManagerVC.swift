//
//  IMGroupDynamicManagerVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/16.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit


class GroupDynamicManagerVC: BaseVC {

    
    var groupId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "群组管理";
        // Do any additional setup after loading the view.
        self.setupSubviews();
        self.distributionSubview();
        self.tableView.beginLoadData();
        
    }
    private func setupSubviews() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "新增动态", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarbuttonClick))
        self.view.addSubview(self.tableView);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.loadDataCallback = {
            [weak self] (page, callback) in
            networkGroupID = self?.groupId ?? "";
            NetWorkRequestModel(network: HomeNetwork.getGroupDetailDynamicList(pageSize: 10, pageIndex: page), listKey: nil, modelType: GroupDetailDynaicModel.self, finished: { (response) in
                callback(response ?? []);
            });
        }
        
    }
    
    @objc private func rightBarbuttonClick() {
        let vc = CreateDynamicVC.init();
        vc.groupid = self.groupId;
        vc.finishedCallback = {
            [weak self] in
            self?.tableView.beginLoadData();
        }
        self.navigationController?.pushViewController(vc, animated: true);
    }
    private func distributionSubview() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    
    private lazy var tableView: WNTableView = {
        let view = WNTableView();
        view.tableFooterView = UIView.init();
        view.register(UINib.init(nibName: "GroupDetailDynamicCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.pageSize = 10;
        return view;
    }()
    private var cellHeightCache:[Int : CGFloat] = [:];
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GroupDynamicManagerVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupDetailDynamicCell
        cell.model = (self.tableView.dataSources[indexPath.row] as! GroupDetailDynaicModel);
        cell.showCanEdite();
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 100;
        if let cellHeight = self.cellHeightCache[indexPath.row] {
            height = cellHeight;
        } else {
            let model = self.tableView.dataSources[indexPath.row] as! GroupDetailDynaicModel;
            height = model.calculateCellHeight();
        }
        return height;
    }
    
}
