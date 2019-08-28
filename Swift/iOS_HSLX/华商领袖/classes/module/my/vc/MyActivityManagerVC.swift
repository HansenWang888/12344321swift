//
//  MyActivityManagerVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class MyActivityManagerVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    var model: ActivityGroupListModel? {
        
        didSet {
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "活动管理";
        self.view.backgroundColor = .groupTableViewBackground;
        
        self.setupSubviews();
        self.distributionSubview();
        
    }
    private func setupSubviews() {
        
        self.view.addSubview(self.tableView);
        
        
    }
    
    private func distributionSubview() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    private var dataSources: [String] = ["活动编辑","报名管理","高级功能","社会分享","查看详情","关闭报名"];
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self;
        view.delegate = self;
        view.tableFooterView = UIView.init();
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        return view;
    }()


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.dataSources[indexPath.row];
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        var vc: UIViewController?;
        switch indexPath.row {
        case 0:
            vc = CreateActivytyVC.activityVCModify(self.model!);
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
           let realVC = ActivityDetailVC.init();
           realVC.activityID = self.model?.id;
           vc = realVC;
            break;
        case 5:

            UIAlertController.showCustomAlertVC(message: "是否关闭活动报名", confirmTitle: "确定") { (_) in
                SVProgressHUD.show(withStatus: nil);
                NetWorkRequest(target: ActivityNetwork.closeActivityApply, finished: { (result) in
                    
                    switch result {
                    case .successful:
                        
                        SVProgressHUD.showSuccess(withStatus: "关闭成功");
                        break
                        
                    case .failure(let errmsg) :
                        SVProgressHUD.showError(withStatus: errmsg)
                        break
                        
                    }
                })
            }
            break;
        default:
            break;
        }
        if vc != nil {
            self.navigationController?.pushViewController(vc!, animated: true);
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
