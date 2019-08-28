//
//  IMSessionListVC.swift
//  TencentIM
//
//  Created by hansen on 2019/4/29.
//  Copyright © 2019 hansen. All rights reserved.
//

import UIKit

import MJRefresh

class IMSessionListVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(rightBarBtnClick))
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.loadData();
    }
    
    @objc private func loadData() {
        self.dataSources.removeAll();
        let array = IMSessionManager.getSessionList();
        var ids:[String] = [];
        var groupids: [String] = [];
        for item in array ?? [] {
            
            if item.getType() == .SYSTEM {
                continue;
            }
            let lastMessage = item.getLastMsg();
            let model = TConversationCellData.init();
            model.unRead = item.getUnReadMessageNum();
            model.subTitle = self.getDateDisplayString(item);
            model.time = self.getLastDisplayString(date: lastMessage?.timestamp() ?? Date.init());
            model.convId = item.getReceiver();
            model.convType = TConvType(rawValue: UInt(item.getType().rawValue))!;
            model.title = "...";
            model.head = kDefaultAvatarPath;
            
            if model.convType == TConvType.type_Group {
                model.title = item.getGroupName();
            }
            self.dataSources.append(model);
            if model.convType == .type_Group {
                groupids.append(model.convId);
            } else if model.convType == .type_C2C {
                ids.append(model.convId);
            }
        }
        self.tableView.reloadData();
        IMUserManager.getUsersInfo(ids) { (response) in
            
            if response != nil {
                
                for item in response! {
                    
                    for model in self.dataSources {
                        
                        if model.convId == item.identifier {
                            model.title = item.nickname;
                            model.head = item.faceURL;
                            break;
                        }
                    }
                }
                self.tableView.reloadData();
            }
        }
        
        IMGroupManager.getGroupsInfo(groupids) { (response) in
            
            if response != nil {
                
                for item in response! {
                    
                    for model in self.dataSources {
                        
                        if model.convId == item.group {
                            model.title = item.groupName;
                            model.head = item.faceURL;
                            break;
                        }
                    }
                }
                self.tableView.reloadData();
            }
        }
        self.tableView.mj_header.endRefreshing();
        
    }
    
    private func getDateDisplayString(_ conv: TIMConversation) -> String {
        
        var str = "";
        
        guard let draft = conv.getDraft() else {
            return str;
        }
        for index in 0...draft.elemCount() {
            
            let elem = draft.getElem(index);
            
            if elem is TIMTextElem {
                
                str = "[草稿]" + (elem as! TIMTextElem).text;
                break;
            }
        }
        if str.count > 0 {
            return str;
        }
        
        guard let lastmsg = conv.getLastMsg() else {
            return str;
        }
        
        if lastmsg.status() == TIMMessageStatus.MSG_STATUS_LOCAL_REVOKED {
            
            if lastmsg.isSelf() {
                return "你撤回了一条消息";
            } else {
                return "\(lastmsg.sender() ?? "对方")撤回了一条消息)";
            }
            
        }
        
        for index in 0...lastmsg.elemCount() {
            
            let elem = lastmsg.getElem(index);
            
            if elem is TIMTextElem {
                
                str = (elem as! TIMTextElem).text;
                
                break;
            } else if elem is TIMCustomElem {
                str = lastmsg.getOfflinePushInfo().ext ?? "";
                break;
            } else if elem is TIMImageElem {
                str = "[图片]";
                break;
            } else if elem is TIMSoundElem {
                str = "[语音]";
                break;
            } else if elem is TIMVideoElem {
                str = "[视频]";
                break;
            } else if elem is TIMFaceElem {
                str = "[动画表情]";
                break;
            } else if elem is TIMFileElem {
                str = "[文件]";
                break;
            } else if elem is TIMGroupTipsElem {

                let tips = elem as! TIMGroupTipsElem
                switch tips.type {
                    
                case TIM_GROUP_TIPS_TYPE.INFO_CHANGE:
                
                    str = "修改群信息...";
                    break;
                case TIM_GROUP_TIPS_TYPE.KICKED:
                    let users = tips.userList as! [String];
                    let string = users.joined(separator: "、");
                    str = "\(tips.opUser!)将\(string)踢出群组";
                    break;
                case TIM_GROUP_TIPS_TYPE.INVITE:
                    let users = tips.userList as! [String];
                    let string = users.joined(separator: "、");
                    str = "\(tips.opUser!)将\(string)加入群组";
                    break;
                default:
                    break;
                }
                
            } else {
                
                continue;
            }
        }
        
        
        return str
        
    }
    
    private func getLastDisplayString(date: Date) -> String {
        
        let calendar = Calendar.current;
        
        let unit:Set<Calendar.Component> = [Calendar.Component.day, Calendar.Component.month , Calendar.Component.year];
        let nowCp = calendar.dateComponents(unit, from: Date.init());
        let myCp = calendar.dateComponents(unit, from: date);
        
        let dateForm = DateFormatter.init();
        
        let component = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekday] , from: date);
        
        if nowCp != myCp {
            dateForm.dateFormat = "yyyy/MM/dd";
        } else {
            if nowCp == myCp {
                dateForm.amSymbol = "上午";
                dateForm.pmSymbol = "下午";
                dateForm.dateFormat = "aaa hh:mm";
            } else if (nowCp.day! - myCp.day!) == 1 {
                dateForm.amSymbol = "上午";
                dateForm.pmSymbol = "下午";
                dateForm.dateFormat = "昨天";
            } else {
                
                if (nowCp.day! - myCp.day!) <= 7{
                    
                    switch component.weekday {
                        
                    case 1:
                        dateForm.dateFormat = "星期日";
                        break;
                    case 2:
                        dateForm.dateFormat = "星期一";
                        break;
                    case 3:
                        dateForm.dateFormat = "星期二";
                        break;
                    case 4:
                        dateForm.dateFormat = "星期三";
                        break;
                    case 5:
                        dateForm.dateFormat = "星期四";
                        break;
                    case 6:
                        dateForm.dateFormat = "星期五";
                        break;
                    case 7:
                        dateForm.dateFormat = "星期六";
                        break;
                    default:
                        break;
                    }
                } else {
                    dateForm.dateFormat = "yyyy/MM/dd";
                }
            }
        }
        return dateForm.string(from: date);
    }
    
    
    

    @objc private func rightBarBtnClick () {
        
        let vc  = IMFriendListVC.init()
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView.init()
        view.dataSource = self
        view.delegate = self
        view.register(TConversationCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    private var dataSources: [TConversationCellData] = []

}


extension IMSessionListVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TConversationCell.getSize().height;
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete;
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除";
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let conv = self.dataSources[indexPath.row];
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.none);
        var type: TIMConversationType = .C2C;
        if conv.convType == TConvType.type_Group {
            type = .GROUP;
        } else if conv.convType == .type_C2C {
            type = .C2C;
        }
        TIMManager.sharedInstance()?.deleteConversationAndMessages(type, receiver: conv.convId);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TConversationCell
        cell.setData(self.dataSources[indexPath.row]);
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = IMChatVC.init()
        vc.conversationData = self.dataSources[indexPath.row];
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    
}
