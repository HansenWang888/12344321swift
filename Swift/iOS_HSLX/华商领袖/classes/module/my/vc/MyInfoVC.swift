//
//  MyInfoVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/5.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh
/**
 * 个人主页页面
 *
 */
class MyInfoVC: BaseVC {

    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var subNameLabel: UILabel!
    
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var vipBtn: UIButton!
    @IBOutlet weak var authorizationBtn: UIButton!
    @IBOutlet weak var editeBtn: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    private var headerView: UIView?
//    var userID: Int?
//    var nickName: String?
//    var avatarURL: String?
//    ///1 已关注 2 相互关注
//    var followStatus: Int = 0
    var userid: Int?
    private var userInfo: UserModel?
    override func viewDidLoad() {
        self.title = "个人主页"
        super.viewDidLoad()
        self.setupSubview()
        self.tableView.mj_header.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    
    private func setupSubview() {
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.loadDataCallback = {
            [weak self] (pageIndex, callback) in
            if pageIndex == 0 {
                self?.loadData()
            }
            NetWorkRequestModel(network: MyNetwork.getUserDynamics(page: pageIndex, size: 10), listKey: nil, modelType: HomeDynamicModel.self, finished: { (responses) in
                callback(responses ?? [])
                self?.calculateCellHeight(page: pageIndex)
            })
        }
        self.headerView = Bundle.main.loadNibNamed("MyInfoHeaderView", owner: self, options: nil)?.first as? UIView
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 320)
        self.contentView.addRoundedOrShadow(radius: 8)
        self.contentView.addBorder(width: 0.5, borderColor: UIColor.lightGray)
        if LoginManager.manager.user?.userId == self.userid{
            self.editeBtn.isHidden = false
        } else {
            self.editeBtn.isHidden = true
            self.bottomView.updateTitle(index: 0, title: ["+关注","已关注","相互关注"][self.userInfo?.fStatus ?? 0])
            self.view.addSubview(self.bottomView)
            self.bottomView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(50)
            }
            self.bottomView.btnClickBlock = {
                [weak self] (index) in
               self?.bottombtnClick(index: index)

            }
        }
        
    }
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 320)

    }
    
    private func bottombtnClick(index : Int) {
        if index == 0 {
            CommonHandler.handleAttentionOrNot(targetID: self.userid ?? 0, status: self.userInfo?.fStatus ?? 0) { (result) in
                
                if result != nil {
                    SVProgressHUD.dismiss()
                    self.userInfo?.fStatus = result!
                    self.bottomView.updateTitle(index: 0, title: ["+关注","已关注","相互关注"][self.userInfo?.fStatus ?? 0])
                }
            }
        } else {
            
            let vc = IMChatVC.init()
            let conversation = TConversationCellData.init()
            conversation.convType = TConvType.type_C2C
            conversation.title = self.userInfo?.nickName;
            conversation.convId = "\(self.userid ?? 0)"
            conversation.head = self.userInfo?.headUrl;
            vc.conversationData = conversation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func updateHeaderView() {
        
        self.avatarImgV.kf.setImage(with: URL.init(string: self.userInfo?.headUrl ?? ""), placeholder: kDefaultAvatarImage, options: nil, progressBlock: nil) { (image, _, _, _) in
            self.avatarImgV.setCornerImage()
        }
        self.nameLabel.text = self.userInfo?.nickName
        self.subNameLabel.text = self.userInfo?.companyName
        if self.userInfo?.phone?.count ?? 0 > 0 {
            self.phoneBtn.setTitle(self.userInfo?.phone, for: UIControl.State.normal)
            self.phoneBtn.isHidden = false
        } else {
            self.phoneBtn.isHidden = true
        }
        if self.userInfo?.address?.count ?? 0 > 0 {
            self.addressBtn.setTitle(self.userInfo?.address, for: UIControl.State.normal)
            self.addressBtn.isHidden = false
        } else {
            self.addressBtn.isHidden = true
        }
        if self.userInfo?.vipLevel ?? 0 > 0 {
            self.vipBtn.setTitle("白银会员", for: UIControl.State.normal)
            self.vipBtn.isHidden = false
        } else {
            self.vipBtn.isHidden = true
        }
        if self.userInfo?.isRealName ?? 0 == 2 {
            self.authorizationBtn.setTitle("实名认证", for: UIControl.State.normal)
            self.authorizationBtn.isHidden = false
        } else {
            self.authorizationBtn.isHidden = true
        }
        self.bottomView.updateTitle(index: 0, title: ["+关注","已关注","相互关注"][self.userInfo?.fStatus ?? 0])
       
    
    }
    @objc private func loadData() {
        
        kTargetUserID = self.userid ?? 0
        NetWorkRequest(target: MyNetwork.getSomeoneUserInfo) { (result) in
            self.tableView.mj_header.endRefreshing()
            switch result {
            case .successful(let response):
                let dict = response as! [String : Any]
                self.userInfo = UserModel.init(JSON: dict)
                self.updateHeaderView()
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        NetWorkRequest(target: MyNetwork.getUserUnits) { (result) in
            self.tableView.mj_header.endRefreshing()

            switch result {
            case .successful(let response):
                let dict = response as? [[String : Any]]
                if dict != nil {
                    //获取显示营业范围
                    let array = (dict![0]["businessScope"] as? String)?.components(separatedBy: "@#")
                    debugPrint("营业范围 === \(array)")
                    
                }
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
    }
    
    private func calculateCellHeight(page: Int) {
        let width = self.view.width
        DispatchQueue.global().async {
            let startIndex = self.heightDict.keys.count
            var indexes : [IndexPath] = []
            for index in startIndex ..< self.tableView.dataSources.count {
                var cellHeight:CGFloat = 100 + 47
                let item = self.self.tableView.dataSources[index] as! HomeDynamicModel
                let textHeight = item.content?.getTextHeigh(font: UIFont.systemFont(ofSize: 15), width: width - 30) ?? 0
                var pictureHeight: CGFloat = 0
                var array: [String] = item.picture?.components(separatedBy: ",") ?? []
                if array.last?.count == 0 {
                    array.removeLast()
                }
                if array.count > 0 {
                    let pictureWH = (width - 30 - 10) / 3
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
                cellHeight = textHeight + pictureHeight + cellHeight
                self.heightDict[index] = cellHeight
                indexes.append(IndexPath.init(row: index, section: 0))
               
            }
            DispatchQueue.main.async {
                if page == 0 {
                    self.tableView.reloadData()
                } else {
                    self.tableView.reloadRows(at: indexes, with: UITableView.RowAnimation.none)
                }
            }
        }
    }
    
    
    @IBAction func editeBtnClick(_ sender: Any) {
        
    }
    
    @IBAction func phoneBtnClick(_ sender: Any) {
        
    }
    
    @IBAction func storeBtnClick(_ sender: Any) {
        
    }
    
    @IBAction func websiteBtnClick(_ sender: Any) {
        
    }
    
    @IBAction func opportunityBtnClick(_ sender: Any) {
        
        
    }
    
    private var heightDict: [Int : CGFloat] = [:]
    
    private lazy var tableView: WNTableView = {
        let view = WNTableView()
        view.tableFooterView = UIView.init()
        view.separatorColor = UIColor.clear
        view.dataSource = self
        view.delegate = self
        view.register(UINib.init(nibName: "HomeListCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        return view
    }()
    
    private lazy var bottomView: DYBottomCtrlView = {
        let view = DYBottomCtrlView(titles: ["关注", "对话"])
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

extension MyInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeListCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.model = self.tableView.dataSources[indexPath.row] as? HomeDynamicModel
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.heightDict[indexPath.row] ?? 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
