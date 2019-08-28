//
//  DynamicDetailVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DynamicDetailVC: BaseVC {

    
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    private var headerHeight: CGFloat = 100;
    var model:HomeDynamicModel? {
        
        didSet {
            
            self.headerHeight = self.model?.calculateCellHeight() ?? 50 - 50;
            self.headerView.model = self.model;
           
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "动态正文";
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview();
            make.bottom.equalTo(self.bottomView.snp.top);
        }
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.headerHeight)

        self.tableView.beginLoadData();
        if self.model?.likes == 0 {
            self.likeBtn.setTitle(" 赞", for: UIControl.State.normal);
        } else {
            self.likeBtn.setTitle("\(self.model?.likes ?? 0)" , for: UIControl.State.normal);
        }
        self.likeBtn.isSelected = self.model?.likeType == 1 ? true : false;
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.headerHeight)
    }
    @IBAction func sharBtnClick(_ sender: Any) {
       
    }
    
    @IBAction func commentBtnClick(_ sender: Any) {
        DYCommentEditView.show(onView: nil) {[weak self] (content) in
            
            SVProgressHUD.show(withStatus: nil);
            
            NetWorkRequest(target: HomeNetwork.commitComment(composeId: self?.model?.id ?? 0, composeType: 1, content: content), finished: { (result) in
                
                switch result {
                case .successful:
                    SVProgressHUD.showSuccess(withStatus: "评论成功！");
                    self?.tableView.beginLoadData();
                    
                    break
                    
                case .failure(let errmsg) :
                    SVProgressHUD.showError(withStatus: errmsg)
                    break
                    
                }
            })
            
        }
    }
    
    @IBAction func likeBtnClick(_ sender: Any) {
        SVProgressHUD.show(withStatus: nil)
        NetWorkRequest(target: HomeNetwork.likeDynamic(status: self.likeBtn.isSelected ? 0 : 1, type: 1, typeId: self.model?.id ?? 0)) { (result) in
            
            switch result {
                
            case .successful:
                SVProgressHUD.dismiss()
                if self.likeBtn.isSelected {
                    //                    取消点赞
                    self.likeBtn.isSelected = false
                    self.model?.likeType = 0
                    self.model?.likes = (self.model?.likes ?? 1) - 1
                    self.likeBtn.setTitle(" \(self.model?.likes ?? 0)", for: UIControl.State.normal)
                    if self.model?.likes == 0 {
                        self.likeBtn.setTitle(" 赞", for: UIControl.State.normal)
                    }
                    
                } else {
                    //                    点赞
                    self.likeBtn.isSelected = true
                    self.model?.likeType = 1
                    self.model?.likes = (self.model?.likes ?? 0) + 1
                    self.likeBtn.setTitle(" \(self.model?.likes ?? 0)", for: UIControl.State.selected)
                }
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
    }
    
    private lazy var headerView: HomeDynamicContentView = {
        let view = HomeDynamicContentView.initGroupDynamicView();
        
        return view;
    }()

    
    private lazy var tableView: WNTableView = {
        let view = WNTableView()
        view.tableFooterView = UIView.init();
        view.dataSource = self;
        view.delegate = self;
        view.register(UINib.init(nibName: "DynamicCommentCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.loadDataCallback = {
            [weak self] (page, callback) in
            return NetWorkRequestModel(network: HomeNetwork.getDynamicCommentList(page: page, size: 10, composeType: 1, composeId: self?.model?.id ?? 0), listKey: nil, modelType: DynamicCommentModel.self, finished: { (response) in
                callback(response ?? []);
            })
        }
        
        return view;
    }()
    

}


extension DynamicDetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DynamicCommentCell;
        cell.model = (self.tableView.dataSources[indexPath.row] as! DynamicCommentModel);
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = self.tableView.heightCache[indexPath.row] else {
            
            let model = self.tableView.dataSources[indexPath.row] as! DynamicCommentModel;
            
            return model.calculateCellHeight();
        }
        return height;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.tableView.dataSources[indexPath.row] as! DynamicCommentModel;
        
        let view = DYCommentEditView.init();
        view.placeHolder = "回复 " + (model.nickName ?? " ") + "的评论";
        view.show(onView: nil) { [weak self] (content) in
            SVProgressHUD.show(withStatus: nil);
            NetWorkRequest(target: HomeNetwork.replyComment(commentId: model.id ?? 0, content: content, replyId: model.composeId ?? 0, replyType: model.composeType ?? 1, toUserId: model.userId ?? 0), finished: { (result) in
                switch result {
                case .successful:
                    SVProgressHUD.showSuccess(withStatus: "回复成功");
                    self?.tableView.beginLoadData();
                    break
                    
                case .failure(let errmsg) :
                    SVProgressHUD.showError(withStatus: errmsg)
                    break
                    
                }
            })
        }
        
    }
    
    
}
