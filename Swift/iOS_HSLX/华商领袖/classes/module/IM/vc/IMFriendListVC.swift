//
//  IMFriendListVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/5.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class IMFriendListVC: BaseVC {

    
    private var currentSlectIndex = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubview();
        self.title = "好友";
        // Do any additional setup after loading the view.
    }
    
    private func setupSubview() {
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(64);
            make.height.equalTo(50);
        }
        self.headerView.selectIndexBlock = {
            [weak self] (index) in
            self?.updateTitle(index);
            self?.collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false);
            
        }
        
       
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        for index in 0...5 {
            
            let view: WNTableView = WNTableView.init()
            view.delegate = self
            view.dataSource = self
            view.type = index;
            view.rowHeight = 80;
            switch index {
            case 0:
                view.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell");
                view.loadDataCallback = {
                    (pageIndex,callback) in
                    NetWorkRequestModel(network: IMNetwork.getFriends(page: pageIndex, size: 10, fromUserId: LoginManager.manager.user?.userId ?? 0), listKey: "standardList",modelType: NearbyPersonModel.self, finished: { (array) in
                        callback(array ?? [])
                    })
                }
                
                break
            case 1:
                view.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell");
                view.loadDataCallback = {
                    (pageIndex,callback) in
                    NetWorkRequestModel(network: IMNetwork.getAttentions(page: pageIndex, size: 10, fromUserId: LoginManager.manager.user?.userId ?? 0), listKey: "standardList",modelType: NearbyPersonModel.self, finished: { (array) in
                        callback(array ?? [])
                    })
                }
                break
            case 2:
                view.register(UINib.init(nibName: "HomeFriendInfoCell", bundle: nil), forCellReuseIdentifier: "cell");
                view.loadDataCallback = {
                    (pageIndex,callback) in
                    NetWorkRequestModel(network: IMNetwork.getFollows(page: pageIndex, size: 10, toUserId: LoginManager.manager.user?.userId ?? 0), listKey: "standardList",modelType: NearbyPersonModel.self, finished: { (array) in
                        callback(array ?? [])
                    })
                }
                break
            case 3...5:
                //不支持翻页
                view.register(UINib.init(nibName: "SearchListCell", bundle: nil), forCellReuseIdentifier: "cell");
                view.pageSize = 0
                view.loadDataCallback = {
                    (pageIndex,callback) in
                    NetWorkRequestModel(network: IMNetwork.getGroupList(categoryType: index - 2), listKey: nil,modelType: SearchLishtModel.self, finished: { (array) in
                        callback(array ?? [])
                    })
                }
                
                break
            default:
                break
            }
            
            view.mj_header.beginRefreshing();
            self.dataSources.append(view)
        }
    }
    private func updateTitle(_ index: Int) {
        let array = ["好友","关注","粉丝","社群","商协会","俱乐部"]
        self.title = array[index];
        self.currentSlectIndex = index;
    }
    
    private lazy var headerView: DYSliderHeadView = {
        let view = DYSliderHeadView.init(titles: ["好友","关注","粉丝","社群","商协会","俱乐部"])
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        let view = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
        view.isPagingEnabled = true;
        view.backgroundColor = UIColor.white;
        return view
    }()
    
    private var dataSources: [WNTableView] = []


//    private func createTableView<Request,Model>(tag: Int, loadData: @escaping () -> Request, loadMore: @escaping (_ pageIndex: Int) -> Request) -> DYTableView<Request, Model> {
//
//        let view = DYTableView<Request,Model>.init()
//        view.dataSource = self
//        view.delegate = self
//        view.tag = tag
//        view.pageSize = 10
//        view.pageIndex = 0
//        view.loadDataCallback = loadData
//        view.loadMoreDataCallback = loadMore
//        return view
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension IMFriendListVC : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSources.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath);
        if cell.contentView.subviews.count > 0 {
            cell.contentView.subviews.first?.removeFromSuperview();
        }
        let view = self.dataSources[indexPath.row];
        cell.contentView.addSubview(view);
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.size
    }
    
    
}


extension IMFriendListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return (tableView as! WNTableView).dataSources.count as Int
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell?
        let realTableView = tableView as! WNTableView;
        let type = realTableView.type as! Int;
        switch type {
        case 0...2:
            
            let hCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeFriendInfoCell
            if type == 0 {
                hCell.type = 1;
            }
            hCell.model = (realTableView.dataSources[indexPath.row] as! NearbyPersonModel);
            cell = hCell;
            break;
        default:
            let hCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchListCell
            hCell.model = (realTableView.dataSources[indexPath.row] as! SearchLishtModel);
            cell = hCell;
            break;
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none;
        return cell!
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = self.collectionView.indexPath(for: self.collectionView.visibleCells.first!);
        self.headerView.updateSelectIndexFromOther(index!.item);
        self.updateTitle(index!.item);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let realTableView = tableView as! WNTableView;
        
        switch realTableView.type as! Int {
        case 0...2:
            let vc = MyInfoVC.init();
            let model = realTableView.dataSources[indexPath.row] as! NearbyPersonModel
            vc.userid = model.userId;
            self.self.navigationController?.pushViewController(vc, animated: true);
            break;
        default:
            
            let model = realTableView.dataSources[indexPath.row] as! SearchLishtModel
            if model.authStatus != 0 {
                let conversaton = TConversationCellData.init();
                conversaton.convId = model.groupId;
                conversaton.head = model.groupUri;
                conversaton.convType = TConvType.type_Group;
                conversaton.title = model.groupName;
                let vc = IMChatVC.init()
                vc.conversationData = conversaton;
                self.navigationController?.pushViewController(vc, animated: true);
            }
            break;
        }
        
    }
}
