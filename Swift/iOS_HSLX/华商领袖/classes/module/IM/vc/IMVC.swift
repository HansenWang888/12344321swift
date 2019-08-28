//
//  IMVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import MJRefresh

class IMVC: TConversationController,TConversationControllerDelegagte {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupSubviews();
        self.distributionSubview();
        
        
    }
    private func setupSubviews() {
        self.delegate = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            [weak self] in
            self?.updateConversations();
        })
        let imagePath = kTUIKitResourcePath("person_nav")!;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imagePath), style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarBtnClick));
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "动态列表", style: UIBarButtonItem.Style.plain, target: self, action: #selector(letBarbtnClick));
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewMessages), name: NSNotification.Name.init("TUIKitNotification_TIMRefreshListener"), object: nil);
    }
    private func distributionSubview() {
        
        self.tabBarController?.tabBar.addSubview(self.unreadView!);
        self.unreadView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10);
            let width = kScreenWidth / CGFloat(self.tabBarController!.tabBar.items!.count);
            make.right.equalToSuperview().offset(-(width + width * 0.3));
        })
       
    }
    @objc private func letBarbtnClick() {
        
        let vc = IMCommonLikeListVC.init();
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    @objc private func rightBarBtnClick() {
        
        let vc = IMFriendListVC.init();
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    @objc private func updateNewMessages() {
        
        let array = IMSessionManager.getSessionList();
        var totalUnread:Int32 = 0;
        for item in array ?? [] {
            
           totalUnread += item.getUnReadMessageNum();
        }
        self.unreadView?.setUnreadNumber(Int(totalUnread));
    }
    
//    override func updateConversationList(_ list: [TConversationCellData]!) {
//
//        if self.dataSources()?.count == 0 {
//            self.updateConversations();
//        } else {
//            var indexes: [IndexPath] = []
//            var inserts: [IndexPath] = []
//            for item in list {
//
//                if self.dataSources()!.contains(item) {
//                    let index = self.dataSources()?.index(of: item);
//                    indexes.append(IndexPath.init(row: index!, section: 0));
//                } else {
//                    inserts.append(IndexPath.init(row: self.dataSources()!.count, section: 0));
//                    self.dataSources()?.add(item);
//                }
//
//            }
//            if inserts.count > 0 {
//                self.tableView.insertRows(at: inserts, with: UITableView.RowAnimation.none);
//            }
//            if indexes.count > 0 {
//                self.tableView.reloadRows(at: indexes, with: UITableView.RowAnimation.none);
//            }
//        }
//
//    }
//    private func handlerSessionData(_ data: TConversationCellData) {
//
//    }
    override func updateConversations() {
        var totalUnreadNum: Int32 = 0;
        let array = IMSessionManager.getSessionList();
        self.dataSources()?.removeAllObjects();
        var ids:[String] = [];
        var groupids: [String] = [];
        for item in array ?? [] {
            if item.getType() == .SYSTEM {
                continue;
            }
            var model = TConversationCellData.init();
            if let cacheModel = IMSessionManager.shared.sessionList[item.getReceiver()] {
                model = cacheModel;
                
            } else {
                model.convId = item.getReceiver();
                model.convType = TConvType(rawValue: UInt(item.getType().rawValue))!;
                model.title = "...";
                model.head = item.getReceiver();
                if model.convType == TConvType.type_Group {
                    model.title = item.getGroupName();
                }
                if model.convType == .type_Group {
                    groupids.append(model.convId);
                } else if model.convType == .type_C2C {
                    ids.append(model.convId);
                }
            }
            let lastMessage = item.getLastMsg();
            model.unRead = item.getUnReadMessageNum();
            totalUnreadNum += item.getUnReadMessageNum();
            model.time = self.getDateDisplayString(lastMessage?.timestamp() ?? Date.init());
            model.subTitle = self.getLastDisplayString(item);
            
            self.dataSources()?.add(model);
            
        }
        self.tableView.reloadData();
        IMUserManager.getUsersInfo(ids) { (response) in
            
            if response != nil {
                for item in response! {
                    
                    for model in (self.dataSources() as! [TConversationCellData]) {
                        
                        if model.convId == item.identifier {

                            model.title = item.nickname;
                            model.head = item.faceURL;
                            IMSessionManager.shared.sessionList[model.convId] = model;
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
                    
                    for model in (self.dataSources() as! [TConversationCellData]) {
                        
                        if model.convId == item.group {
                            model.title = item.groupName;
                            model.head = item.faceURL;
                            IMSessionManager.shared.sessionList[model.convId] = model
                           
                            break;
                        }
                    }
                }
                
                self.tableView.reloadData();
            }
        }
        self.tableView.mj_header.endRefreshing();
        self.unreadView?.setUnreadNumber(Int(totalUnreadNum));
    }
    
    
    func conversationController(_ conversationController: TConversationController!, didSelectConversation conversation: TConversationCellData!) {
        
        let vc = IMChatVC.init();
        vc.conversationData = conversation;
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
        
        
    }
    
    func conversationController(_ conversationController: TConversationController!, didClickRightBarButton rightBarButton: UIButton!) {
        
    }
    
    private lazy var unreadView: DYUnreadView? = {
        let view = DYUnreadView();
        
        return view;
    }()

    deinit {
        NotificationCenter.default.removeObserver(self);
        self.unreadView!.removeFromSuperview();
        self.unreadView = nil;
    }
    
    
}
