//
//  ActivityGroupDetalVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/25.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

class ActivityDetailVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleImageV: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beginTime: UILabel!

    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var vipDiscounts: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var organization: UILabel!
    @IBOutlet weak var subOrganization: UILabel!
    @IBOutlet weak var signedLabel: UILabel!

    @IBOutlet weak var activityDesc: UITextView!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var descView: UIView!
    
    @IBOutlet weak var allBtn: UIButton!
    
    var activityID: String?
    
    private var model: ActivityGroupListModel?
    private var dataSources: [NearbyPersonModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "活动详情"
        self.setupSubview()
        self.tableView.mj_header.beginRefreshing()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "分享"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(shareBtnClick))
        self.tableView.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell");
        self.tableView.rowHeight = 80;
        self.allBtn.addTarget(self, action: #selector(allBtnClick), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func shareBtnClick () {
        SVProgressHUD.showInfo(withStatus: "developing...")
        
    }
    @objc private func allBtnClick() {
        
        let vc  = ActivityApplyListVC.init();
        vc.activityID = self.activityID ?? "";
        self.navigationController?.pushViewController(vc, animated: true);
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.signedLabel.frame.maxY)
        
    }
    private func update () {
        
        self.titleLabel.text = self.model?.activityTitle
        self.beginTime.text = Date.getFormdateYMDHM(timeStamp: self.model?.startTime ?? 0)
        self.endTime.text = Date.getFormdateYMDHM(timeStamp: self.model?.endTime ?? 0)
        self.costLabel.text = "\(self.model?.cost ?? 0)元/人"
        self.vipDiscounts.text = " 会员优惠\(self.model?.vipCouponCost ?? 0)元 "
        self.address.text = self.model?.detailAddress
        self.scaleLabel.text = "\(self.model?.joinNumber ?? 0)人"
        self.organization.text = self.model?.hostUnit
        self.subOrganization.text = self.model?.coOrganizer
        self.titleImageV.kf.setImage(with: URL.init(string: self.model?.urlPath ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, _, _, _) in
            
        }
        
        let attr = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        if self.model?.description?.length == 0 {
            self.activityDesc.text = "暂无描述"
        } else {
            self.activityDesc.attributedText = try? NSAttributedString.init(data: (self.model?.description ?? "暂无描述").data(using: .unicode)!, options: attr, documentAttributes: nil)
        }
        self.activityDesc.sizeToFit()
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.signedLabel.frame.maxY + self.activityDesc.contentSize.height - self.descView.height)

    }
    
    private func setupSubview () {
        self.tableView.tableHeaderView = Bundle.main.loadNibNamed("ActivityDetaiHeaderView", owner: self, options: nil)?.first as? UIView
        self.allBtn.isHidden = true;
        self.infoView.addRounded(radius: 5)
        self.descView.addRounded(radius: 5)
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.vipDiscounts.addRounded(radius: 3)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.titleImageV.contentMode = .scaleAspectFill
        self.activityDesc.font = UIFont.systemFont(ofSize: 16)
        
        
    }
    @objc private func loadData(){
        
        kNetworkActivityID = self.activityID ?? "0"
        NetWorkRequest(target: ActivityNetwork.getActivityDetail) { (result) in
            self.tableView.mj_header.endRefreshing()
            switch result {
                
            case .successful(let response):
                self.dataSources.removeAll();
                let dict = response as! [String : Any]
                let activityInfo = dict["activityInfo"] as! [String: Any]
                let signList = dict["signList"] as! [[String : Any]];
                for item in signList {
                    self.dataSources.append(NearbyPersonModel.init(JSON: item)!);
                }
                self.signedLabel.text = "已报名（\(dict["signTotal"] ?? 0)）"
                self.model = ActivityGroupListModel.init(JSON: activityInfo)
                if self.dataSources.count > 0 {
                    self.tableView.tableFooterView = nil
                    self.allBtn.isHidden = false;
                } else {
                    self.allBtn.isHidden = true;
                    self.tableView.tableFooterView = self.footerLabel

                }
                self.update()
                self.tableView.reloadData();
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
        NetWorkRequest(target: ActivityNetwork.recordActivityBrowse) { (result) in
            
            switch result {
                
            case .successful:
//                let dict = response as! [String : Any]
                break
                
            case .failure:
//                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
        
    }
    
    @IBAction func locationBtnClick(_ sender: Any) {
        SVProgressHUD.showInfo(withStatus: "developing...")

        
    }
    @IBAction func dialBtnClick(_ sender: Any) {
        if self.model?.phone?.count ?? 0 > 0 {
            let phone = "telprompt://" + self.model!.phone!
            if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                UIApplication.shared.openURL(URL(string: phone)!)
            }
        } else {
            SVProgressHUD.showInfo(withStatus: "没有电话号码")
        }
        
        
//        let vc = UIAlertController.initAlertCustomVC(message: "是否确定拨打\(self.model?.phone ?? "0")?", confirmTitle: "呼叫") { (_) in
//
//
//
//        }
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func modifyBtnClick(_ sender: Any) {
        
        
        let vc = ActivityApplyVC.init();
        vc.model = self.model;
        
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    private var footerLabel: UILabel = {
        
        let label = UILabel.init()
        label.textColor = kThemeTextColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.text = "还木有人报名~"
        label.frame = CGRect.init(x: 10, y: 0, width: kScreenWidth, height: 50)
        return label
        
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


extension ActivityDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeFriendInfoCell;
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
        cell.model = self.dataSources[indexPath.row];
        cell.timeAndDistance.isHidden = true;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MyInfoVC.init();
        vc.userid = self.dataSources[indexPath.row].userId;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
}

