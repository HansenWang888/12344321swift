//
//  IMCommonLikeListVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class IMCommonLikeListVC: BaseVC {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息";
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.tableView.loadDataCallback = {
            (pageIndex, callBack) in
            NetWorkRequestModel(network: IMNetwork.getCommentsAndLikes(page: pageIndex, size: 10), listKey: nil, modelType: IMCommentLikeModel.self, finished: { (responses) in
                callBack(responses ?? []);
            })
        }
        self.tableView.didSelectCellCallback = {
            [weak self] (_, model) in
            
            let vc = DynamicDetailVC.init();
            
            self?.navigationController?.pushViewController(vc, animated: true);
            
        }
        // Do any additional setup after loading the view.
    }

    
    private lazy var tableView: WNTableView = {
        let view = WNTableView();
        view.register(UINib.init(nibName: "IMCommontLikeCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.tableFooterView = UIView.init();
        view.rowHeight = 80;
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

