//
//  HomeHeaderView.swift
//  华商领袖
//
//  Created by abc on 2019/3/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSources: Array<HomeAdvertiseModel> = []
    private var isLoop : Bool = false
    private var beginDragPoint:CGPoint?
    weak var containedVC: UIViewController?
    
    class func initHeaderView () -> HomeHeaderView {
        
        let view = Bundle.main.loadNibNamed("HomeHeaderView", owner: nil, options: nil)?.first as! HomeHeaderView

        return view
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.collectionView.delegate != nil {
            return
        }
        self.setupSubView()
    }
    
    func setupSubView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let layout = AdvertiseLayout()
        layout.lineMargin = 20
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UINib.init(nibName: "HomeAdvertiseViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func updateSources(array: Array<HomeAdvertiseModel>) {
        
        if array.count > 0 {
            self.dataSources.removeAll()
            self.dataSources.append(array.last!)
            self.dataSources.append(contentsOf: array)
            self.dataSources.append(array.first!)
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)

        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func btnClick(_ sender: WNButton) {
        
        var VC: UIViewController?
        switch sender.tag {
        case 1:
            //附件社群
            VC = SearchListVC.init(showType: SearchListShowType.nearbyGroupType(title: "社群列表", searchPlaceholder: "搜索您想要了解的社群吧", rightBarTitle: "创建社群"))

            break
        case 2:
            //华商领袖
            VC = SearchListVC.init(showType: SearchListShowType.HSLXType(title: "华商领袖俱乐部", searchPlaceholder: "搜索您想要了解的俱乐部吧", rightBarTitle: "申请加盟"))
            break
        case 3:
            //商协会
            VC = SearchListVC.init(showType: SearchListShowType.businessAssociation(title: "商协会列表", searchPlaceholder: "搜索您想要了解的商会吧", rightBarTitle: "申请入驻"))

            break
        case 4:
            //创业服务
            VC = HomeBusinessInfoVC.init();
            break
        default:
            break
        }
        VC!.hidesBottomBarWhenPushed = true
        self.containedVC?.navigationController?.pushViewController(VC!, animated: true)

    }
    
}


extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeAdvertiseViewCell
        cell.model = dataSources[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = self.dataSources[indexPath.item];
        
        let vc = ArticleBrowseVC.init();
        vc.articleID = model.articleId!;
        vc.hidesBottomBarWhenPushed = true;
        self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.isLoop {
            self.isLoop = false
            if scrollView.contentOffset.x < self.collectionView!.width * 0.5 && self.beginDragPoint!.x > scrollView.contentOffset.x {
                print("the first cell")
                //            if self.isLoop {
                self.collectionView.scrollToItem(at: IndexPath.init(item: self.dataSources.count - 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                //            }
                return
            }
            if scrollView.contentOffset.x > CGFloat(self.dataSources.count - 2) * scrollView.width + self.collectionView!.width * 0.5 && self.beginDragPoint!.x < scrollView.contentOffset.x {
                print("the last cell")
                self.isLoop = true
                self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                
                return
            }
        }
       
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.beginDragPoint = scrollView.contentOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.isLoop = true
        
    }
    
    
}

