//
//  HomeBusinessInfoVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/22.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class HomeBusinessInfoVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "创业服务中心";
        self.view.addSubview(self.tableViewL);
        self.view.addSubview(self.tableViewR);
        self.loadData();
        self.tableViewL.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview();
            make.width.equalToSuperview().multipliedBy(0.3);
            
        }
        self.tableViewR.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview();
            make.width.equalToSuperview().multipliedBy(0.7);
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func loadData() {
        
        SVProgressHUD.show(withStatus: nil);
        NetWorkRequest(target: HomeNetwork.getBusinessServiceInfo) { (result) in
            
            switch result {
            case .successful(let response):
                SVProgressHUD.dismiss();
                let array = response as! [[String : Any]];
                
                for item in array {
                    let model = BusinessListModel.init(JSON: item)!;
                    if model.categoryList?.count == 0 {
                        model.categoryList?.append(BusinessDetailModel.init(JSON: [:])!);
                    }
                    self.dataSources.append(model);
                    
                }
                self.lastSelected = self.dataSources.first;
                self.lastSelected?.isSelected = true;
                self.tableViewL.reloadData();
                self.tableViewR.reloadData();
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
    }
    
    
    private var lastSelected: BusinessListModel?
    private lazy var tableViewL: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView.init();
        view.dataSource = self;
        view.delegate = self;
        view.register(BusinessListCell.self, forCellReuseIdentifier: "cell");
        view.rowHeight = 50;
        return view;
    }()
    
    private lazy var tableViewR: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView.init();
        view.dataSource = self;
        view.delegate = self;
        view.register(BusinessDetailCell.self, forCellReuseIdentifier: "cell");
        view.rowHeight = 140;
        return view;
    }()
    private var dataSources: [BusinessListModel] = [];

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeBusinessInfoVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableViewL {
            return 1;
        }
        return self.dataSources.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableViewL {
            return self.dataSources.count
            
        }
        return self.dataSources[section].categoryList?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell: UITableViewCell?
        
        if tableView == self.tableViewL {
            let leftCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BusinessListCell;
            leftCell.model = self.dataSources[indexPath.row];
            cell = leftCell;
        
        } else {
            let rightCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BusinessDetailCell;
            rightCell.model = self.dataSources[indexPath.section].categoryList![indexPath.row];
            cell = rightCell;
            
        }
        cell!.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableViewL {
            self.lastSelected?.isSelected = false;
            let model = self.dataSources[indexPath.row];
            model.isSelected = true
            self.lastSelected = model;
            self.tableViewL.reloadData();
            self.tableViewR.scrollToRow(at: IndexPath.init(row: 0, section: indexPath.row), at: .none, animated: true);
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableViewR {
            let label = UILabel.init();
            label.backgroundColor = UIColor.groupTableViewBackground;
            label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold);
            label.text = self.dataSources[section].categoryName;
            label.textColor = UIColor.black;
            return label;
        }
        return nil;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == self.tableViewL ? 0 : 44;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableViewL {
            return 50;
        }
        return self.dataSources[indexPath.section].categoryList![indexPath.row].calculateCellHeight();
    }
    
}

private class BusinessListCell: UITableViewCell {
    
    var model: BusinessListModel? {
        
        didSet {
            
            self.label.text = self.model?.categoryName;
            
            self.label.textColor = self.model!.isSelected ? UIColor.orange : kThemeTextColor;
            self.symbolView.isHidden = self.model!.isSelected ? false : true;
            self.backgroundColor = self.model!.isSelected ? UIColor.white : UIColor.groupTableViewBackground;
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView.addSubview(self.label);
        self.contentView.addSubview(self.symbolView);
        
        self.label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.symbolView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview();
            make.width.equalTo(10);
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center;
        return label;
    }()
    private lazy var symbolView: UIView = {
        let view = UIView();
        view.backgroundColor = UIColor.orange;
        view.isHidden = true;
        return view;
    }()

}


private class BusinessDetailCell: UITableViewCell {
    
    
    var model: BusinessDetailModel? {
        
        didSet {
            
            self.myTitleLabel.text = self.model?.categoryName;
            self.subTitleLabel.text = self.model?.categoryDesc;
            if self.myTitleLabel.text == nil && self.subTitleLabel.text == nil {
                self.noDataView.isHidden = false;
            } else {
                self.noDataView.isHidden = true;
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView.addSubview(self.myTitleLabel);
        self.contentView.addSubview(self.subTitleLabel);
        self.contentView.addSubview(self.noDataView);
        self.noDataView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10);
            make.right.equalToSuperview().offset(-8);
            
        }
        self.subTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.myTitleLabel);
            make.bottom.equalToSuperview().offset(-10);
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    private lazy var myTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14);
        return label;
    }()
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12);
        label.numberOfLines = 0;
        return label;
    }()
    private lazy var noDataView: DYNoDataView = {
        let view = DYNoDataView.defaultView();
        view.isHidden = true;
        return view;
    }()
}
