//
//  ActivityVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class ActivityVC: BaseVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(advancedManager)
        advancedManagerConfig()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addBtnCick))
        self.headerView.delegate = self
    
    }
    private lazy var viewControllers: [UIViewController] = {
        let oneVc = GroupActivityVC()
        let twoVc = GroupActivityVC()
        twoVc.type = 1
        return [oneVc, twoVc]
    }()
    private lazy var titles: [String] = {
        return ["社群活动", "个人活动"]
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = true
        layout.sliderWidth = 20
        layout.titleFont = UIFont.systemFont(ofSize: 14)
        layout.titleViewBgColor = UIColor.white
        layout.titleSelectColor = kThemeColor
        layout.titleColor = UIColor.HWColorWithHexString(hex: "#333333")
        layout.sliderWidth = 40
        layout.sliderHeight = 44
        layout.bottomLineColor = kThemeColor
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = kiPhoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    
    
    private lazy var headerView:UISearchBar = {
        
        let view = UISearchBar()
        view.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 55)
        view.returnKeyType = UIReturnKeyType.search
        view.placeholder = "请输入你要查找的活动关键字"
        return view
    }()
    private lazy var advancedManager: LTAdvancedManager = {
        let advancedManager = LTAdvancedManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            let headerView = strongSelf.headerView
            return headerView
        })
        /* 设置代理 监听滚动 */
        advancedManager.delegate = self as LTAdvancedScrollViewDelegate
        
        /* 设置悬停位置 */
        //        advancedManager.hoverY = 64
        
        /* 点击切换滚动过程动画 */
        advancedManager.isClickScrollAnimation = true
        
        /* 代码设置滚动到第几个位置 */
        //        advancedManager.scrollToIndex(index: viewControllers.count - 1)
        
        return advancedManager
    }()
    
    
    @objc private func addBtnCick() {
        
        let view  = ActivityCreateView.showCreateView()
        view.btnClickBlock = {[weak self] (tag: Int) in
            
            if tag == 3 {
                let vc = UIAlertController.initAlertCustomVC(message: "完成实名认证，享有更多权限", confirmTitle: "去认证", confirmBlock: { [weak self](_) in
                    let vc  = AuthenticateVC()
                    vc.hidesBottomBarWhenPushed = true
                    self!.navigationController?.pushViewController(vc, animated: true)
                })
                self!.present(vc, animated: true, completion: nil)
                return
            }
            
            var vc: UIViewController?
            switch tag {
            case 1:
                //发布动态
                vc = CreateDynamicVC()
                break
            case 2:
                //创建活动
                vc = CreateActivytyVC()
                break
            case 3:
                //发布商机
                vc = CreateOpportunityTypeVC()
                
                break
            case 4:
                //邀请好友
                vc = UIViewController()
                vc?.view.backgroundColor = UIColor.white
                vc?.title = "邀请好友"
                break
            default:
                break
            }
            vc!.hidesBottomBarWhenPushed = true
            self!.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }

}

extension ActivityVC: LTAdvancedScrollViewDelegate , UISearchBarDelegate{
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
        //        advancedManager.advancedDidSelectIndexHandle = {
        ////            print("选中了 -> \($0)")
        //        }
        
    }
    
    func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
        //        print("offset --> ", offsetY)
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
       
        let vc = SearchResultVC<ActivityNetwork,ActivityGroupListModel,ActivityGroupListCell>.init()
        vc.searchPlaceholder = searchBar.placeholder ?? "搜索"
        vc.pageIndex = 0
        vc.pageSize = 5
        vc.cellNib = "ActivityGroupListCell"
        vc.rowHeight = 280
        vc.searchTextChangedCallback = {
            (text) in
            return ActivityNetwork.searchGroupActivityList(key: text, pageSize: 5, pageIndex: 0)
        }
        vc.loadMoreDataCallback = {
            (pageIndex, text) in
            return ActivityNetwork.searchGroupActivityList(key: text, pageSize: 5, pageIndex: pageIndex)
        }
        vc.selectedCellModelCallback = {
            [weak self] (model) in
            
            let vc = ActivityDetailVC.init()
            vc.activityID = model.id
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        return false
    }
}
