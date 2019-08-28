//
//  GroupDetailVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/18.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

import MJRefresh

class GroupDetailVC: BaseVC {
    
    @IBOutlet weak var applyBtn: UIButton!
    //    private var dataSources : [Int: [AnyObject]] = [:]
    private var dynamics: [GroupDetailDynaicModel] = []
    private var members: [GroupDetailMemberModel] = []
    private var groupCtrlCells: [UITableViewCell] = []
    private var activities: [AnyObject] = []
    private var heightDict: [Int: CGFloat] = [:]
    private var totalMember = 0
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var garoupId: String?
    var infoModel: GroupDetaiInfoModel?
    var isInGroup = false;
    var memberInfo: TIMGroupMemberInfo?
    
    
    //MARK: ******method*******
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSubviews();
        self.distributionSubview();
        
    }
    private func setupSubviews() {
        self.headerView = (Bundle.main.loadNibNamed("GroupDetailHeaderView", owner: self, options: nil)?.first as! UIView)
        self.tableView.tableHeaderView = self.headerView
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell1")
        self.tableView.register(UINib.init(nibName: "GroupDetailDynamicCell", bundle: nil), forCellReuseIdentifier: "cell2")
        self.tableView.register(UINib.init(nibName: "GroupDetailDynamicCell", bundle: nil), forCellReuseIdentifier: "cell3")
        self.tableView.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell4")
        self.tableView.register(GroupDetailInfoSectionView.classForCoder(), forHeaderFooterViewReuseIdentifier: "section1")
        self.tableView.register(UITableViewHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "section2")
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        
        self.tableView.mj_header.beginRefreshing()
        self.avatarImgView.addRounded(radius: self.avatarImgView.width * 0.5)
        
        self.view.addSubview(self.groupCtrlView);
        self.groupCtrlView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.applyBtn)
        }
        self.groupCtrlView.btnClickBlock = {
            [weak self] (index) in
            
            switch index {
                
            case 0:
                //发消息
                if self?.isInGroup == false {
                    self?.applyBtnClick(self?.applyBtn as Any);

                } else {
                    let conversation = TConversationCellData.init();
                    conversation.convId = self?.infoModel?.groupId;
                    conversation.head = self?.infoModel?.groupUri;
                    conversation.title = self?.infoModel?.groupName;
                    conversation.convType = .type_Group;
                    let vc = IMChatVC.init();
                    vc.conversationData = conversation;
                    self?.navigationController?.pushViewController(vc, animated: true);
                }
                
                break;
            case 1:
                //活动管理
                let vc = ActivityManagerVC.init();
                vc.groupid = self?.garoupId;
                self?.navigationController?.pushViewController(vc, animated: true);
                
                break;
            case 2:
                //动态管理
                let vc = GroupDynamicManagerVC.init();
                vc.groupId = self?.garoupId;
                
                self?.navigationController?.pushViewController(vc, animated: true);
                break;
            default:
                break;
            }
        }
        
    }
    private func distributionSubview() {
        
    }
    private func updateBottomView() {
        var titles:[String] = [];
        if memberInfo?.role != TIMGroupMemberRole.GROUP_MEMBER_UNDEFINED {
            self.isInGroup = true;
             titles.append("发消息");
            if memberInfo?.role == TIMGroupMemberRole.GROUP_MEMBER_ROLE_ADMIN || memberInfo?.role == TIMGroupMemberRole.GROUP_MEMBER_ROLE_SUPER {
                self.groupCtrlCells.removeAll();
                if memberInfo?.role == TIMGroupMemberRole.GROUP_MEMBER_ROLE_SUPER {
                    let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell5");
                    cell.textLabel?.text = "管理群";
                    cell.detailTextLabel?.text = "设置资料、动态信息等";
                    cell.detailTextLabel?.textColor = UIColor.lightGray;
                    cell.accessoryType = .disclosureIndicator;
                    
                    self.groupCtrlCells.append(cell);
                }
                titles.append("活动管理");
                titles.append("动态管理");
                let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell5");
                cell.textLabel?.text = "消息免打扰";
                let switchView = UISwitch.init();
                switchView.isOn = IMGroupManager.shared.groupConfig[self.garoupId ?? ""] == 1 ? true : false;
                switchView.addTarget(self, action: #selector(switchChanged(_ :)), for: UIControl.Event.valueChanged);
                cell.accessoryView = switchView;
                self.groupCtrlCells.append(cell);
                self.tableView.reloadSections(IndexSet.init(integer: 4), with: UITableView.RowAnimation.none);
            }
            
        }
        if titles.count > 0 {
            self.groupCtrlView.updateTitles(titles);
        }
        
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        
        IMGroupManager.shared.groupConfig[(self.garoupId ?? "")] = sender.isOn ? 1 : 0;
       
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 250)

    }

    private func updateHeaderView() {
        let titleDict = [1: "社群主页",2:"商协会主页",3:"华商领袖俱乐部"]
        self.title = titleDict[self.infoModel?.categoryType ?? 0];
        self.avatarImgView.kf.setImage(with: URL.init(string: self.infoModel?.groupUri ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, _, _, _) in
        }
        self.nameLabel.text = self.infoModel?.groupName
    
        let attr = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        if self.infoModel?.description?.length == 0 {
            self.descLabel.text = "暂无简介"
        } else {
            self.descLabel.attributedText = try? NSAttributedString.init(data: (self.infoModel?.description ?? "暂无简介").data(using: .unicode)!, options: attr, documentAttributes: nil)
        }
        self.descLabel.sizeToFit()
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.descLabel.frame.maxY)
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.none)
       
    }

    @IBAction func applyBtnClick(_ sender: Any) {
        if self.infoModel == nil {
            return
        }
        let vc = GroupApplyVC.init()
        vc.groupid = self.garoupId!;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func loadData () {
        
        var loadIndex = 0
        networkGroupID = self.garoupId ?? ""
        NetWorkRequest(target: HomeNetwork.getGroupDetaiInfo) { (result) in
            
            loadIndex += 1
            if loadIndex == 3 {
                self.tableView.mj_header.endRefreshing();
            }

            switch result {
            case .successful(let response):
                let dict = response as! [String : Any]
                self.infoModel = GroupDetaiInfoModel.init(JSON: dict)
                self.updateHeaderView();
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        NetWorkRequest(target: HomeNetwork.getGroupDetailDynamicList(pageSize: 10, pageIndex: 0)) { (result) in
            loadIndex += 1
            if loadIndex == 3 {
                self.tableView.mj_header.endRefreshing();
            }
            switch result {
                
            case .successful(let response):
                self.dynamics.removeAll()
                self.heightDict.removeAll()
//                let dict = response as! [String : Any]
                let array = response as! [[String:Any]]
                for item in array {
                    self.dynamics.append(GroupDetailDynaicModel.init(JSON: item)!)
                }
                self.calculateCellHeight()
                self.tableView.reloadData()
//                self.tableView.reloadSections(IndexSet.init(integer: 2), with: UITableView.RowAnimation.none)
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
        NetWorkRequest(target: HomeNetwork.getGroupDetailMemberList(pageSize: 10, pageIndex: 0, role: 4)) { (result) in
            loadIndex += 1
            if loadIndex == 3 {
                self.tableView.mj_header.endRefreshing();
            }
            switch result {
                
            case .successful(let response):
                self.members.removeAll();
                let dict = response as! [String : Any]
                let array = dict["memberList"] as! [[String:Any]]
                self.totalMember = dict["total"] as! Int
                for item in array {
                    self.members.append(GroupDetailMemberModel.init(JSON: item)!)
                    
                }
                self.tableView.reloadData()
//                self.tableView.reloadSections(IndexSet.init(integer: 3), with: UITableView.RowAnimation.none)
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        TIMGroupManager.sharedInstance()?.getGroupSelfInfo(self.garoupId, succ: { (memberInfo) in
            
            self.memberInfo = memberInfo;
            self.updateBottomView();
            
        }, fail: { (code, errmsg) in
            
        })
        
    }
    
    private var headerView: UIView?
    
    private func calculateCellHeight() {
        //        DispatchQueue.global().async {
        let startIndex = self.heightDict.keys.count
        for index in startIndex ..< self.dynamics.count {
            var cellHeight:CGFloat = 50
            let item = self.dynamics[index]
            let titleTextHeight = item.title?.getTextHeigh(font: UIFont.systemFont(ofSize: 15), width: self.view.width - 30) ?? 0
            let textHeight = item.content?.getTextHeigh(font: UIFont.systemFont(ofSize: 12), width: self.view.width - 30) ?? 0
            var pictureHeight: CGFloat = 0
            var array: [String] = item.picture?.components(separatedBy: ",") ?? []
            if array.last?.count == 0 {
                array.removeLast()
            }
            if array.count > 0 {
                let pictureWH = (self.view.width - 30 - 10) / 3
                let row = CGFloat(array.count) / 3
                switch row{
                case 0...1:
                    pictureHeight = pictureWH
                    break
                case 1...2:
                    pictureHeight = pictureWH * 2 + 5
                    break
                case 2...3:
                    pictureHeight = pictureWH * 3 + 10
                    break
                default:
                    pictureHeight = 0
                }
                
            }
            cellHeight = textHeight + pictureHeight + cellHeight + titleTextHeight
            self.heightDict[index] = cellHeight
            //            }
        }
    }
    private var groupCtrlView: DYBottomCtrlView = {
        
        let view = DYBottomCtrlView.init(titles: ["申请加入"]);
        
        return view;
        
    }()
    
    
    

}

extension GroupDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.activities.count > 3 ? 3 : self.activities.count
        case 2:
            return self.dynamics.count > 3 ? 3 : self.dynamics.count
        case 3:
            return self.members.count > 3 ? 3 : self.members.count
        case 4:
            return self.groupCtrlCells.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")

        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell.imageView?.image = UIImage.init(named: "办公楼")
            cell.textLabel?.text = self.infoModel?.detailAddress
            cell.imageView?.bounds = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            break
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! GroupDetailDynamicCell
            cell = cell1

            break
        case 2:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! GroupDetailDynamicCell
            cell = cell2
            cell2.model = self.dynamics[indexPath.row]
            break
        case 3:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! HomeFriendInfoCell
            cell = cell3
            cell3.memberModel = self.members[indexPath.row]

            break
        case 4:
            cell = self.groupCtrlCells[indexPath.row];
            
            break
        default:
            break
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            
            return 100
        case 2:
            return self.heightDict[indexPath.row] ?? 100
        case 3:
            return 80
        case 4:
            return 50;
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: UITableViewHeaderFooterView?
        
        switch section {
            
        case 1:
            
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "section1") as? GroupDetailInfoSectionView
            header?.imgView.image = UIImage.init(named: "绿色活动")
            header?.titleLabel.text = "活动"
            return header
        case 2:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "section1") as? GroupDetailInfoSectionView
            header?.imgView.image = UIImage.init(named: "蓝色动态")
            header?.titleLabel.text = "动态"
            
            return header
        case 3:
            header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "section2")
            header?.contentView.backgroundColor = UIColor.white
            if header?.contentView.subviews.count == 0{
                let imgV: UIImageView = UIImageView.init(image: UIImage.init(named: "rightArrow"))
                let leftTitle: UILabel = UILabel.init()
                leftTitle.text = "成员"
                let rightTitle: UILabel = UILabel.init()
                rightTitle.text = "\(self.totalMember) 人"
                rightTitle.tag = 11;
                let btn = UIButton.init()
                btn.addTarget(self, action: #selector(checkMoreMember), for: UIControl.Event.touchUpInside)
                header?.contentView.addSubview(imgV)
                header?.contentView.addSubview(leftTitle)
                header?.contentView.addSubview(rightTitle)
                header?.contentView.addSubview(btn)
                btn.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                imgV.snp.makeConstraints { (make) in
                    make.centerY.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-10)
                }
                leftTitle.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(10)
                }
                rightTitle.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalTo(imgV.snp.right).offset(-10)
                }
            } else {
                let rightLabel = header?.contentView.viewWithTag(11) as! UILabel;
                rightLabel.text = "\(self.totalMember) 人";
            }
            break
        case 4:
            return nil;
        default:
            break
        }
        header?.backgroundColor = UIColor.white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 5
        case 1:
            
            return self.activities.count > 0 ? 50 : 0
        case 2:
            return self.dynamics.count > 3 ? 50 : 0
        case 3:
            return self.members.count > 0 ? 50 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        
        switch section {
        case 0:
            return nil
        case 1:
            return nil
        case 2:
            if self.dynamics.count > 3 {
                let view = UITableViewHeaderFooterView.init()
                view.backgroundView?.backgroundColor = UIColor.clear
                let btn = UIButton.init()
                btn.setTitle("查看更多》", for: UIControl.State.normal)
                btn.addTarget(self, action: #selector(checkMoreDynamic), for: UIControl.Event.touchUpInside)
                btn.setTitleColor(kThemeTextColor, for: UIControl.State.normal)
                btn.backgroundColor = UIColor.white
                view.contentView.addSubview(btn)
                btn.snp.makeConstraints { (make) in
                    make.left.right.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-5)
                }
                return view
            }

            return nil
        case 3:
            return nil
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        case 1:
            
            return self.activities.count > 0 ? 5 : 0
        case 2:
            return self.dynamics.count > 3 ? 50 : 5
        case 3:
            return self.members.count > 0 ? 5 : 0
        case 4:
            return self.groupCtrlCells.count > 0 ? 5 : 0;
        default:
            return 0
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height <= self.tableView.height {
            return;
        }
        let sectionFooterHeight: CGFloat = 50
        let ButtomHeight = scrollView.contentSize.height - self.tableView.height
        
        
        if (ButtomHeight-sectionFooterHeight <= scrollView.contentOffset.y && scrollView.contentSize.height > 0) {
            scrollView.contentInset = UIEdgeInsets.zero;
        } else  {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -(sectionFooterHeight), right: 0);
        }

    }
    
    @objc func checkMoreDynamic() {
        let vc = DetailDynamicListVC.init()
        vc.groupID = self.garoupId!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func checkMoreMember() {
        let vc = DetailMemberListVC.init()
        vc.groupID = self.garoupId!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


private class GroupDetailInfoSectionView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.titleLabel)
        self.imgView.snp.makeConstraints { (make) in
            make.centerY.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(25)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imgView.snp.right).offset(10)
        }
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var imgView: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()


}
