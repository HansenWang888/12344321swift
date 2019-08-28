//
//  GroupDetailDynamicCell.swift
//  华商领袖
//
//  Created by hansen on 2019/4/22.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import JXPhotoBrowser


class GroupDetailDynamicCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    private var dataSources: [String] = []
    var model: GroupDetailDynaicModel? {
        
        didSet {
            var array: [String] = self.model?.picture?.components(separatedBy: ",") ?? []
            if array.last?.count == 0 {
                array.removeLast()
            }
            self.dataSources = array
            self.collectionView.reloadData()
            self.nameLabel.text = self.model?.title
            self.descLabel.text = self.model?.content
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Initialization code
        self.contentView.addSubview(self.editeBtn);
        self.editeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20);
            make.right.equalToSuperview().offset(-20);
        }
        self.editeBtn.addTarget(self, action: #selector(editeBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    func showCanEdite() {
        
        self.editeBtn.isHidden = false;
    }
    
    @objc private func editeBtnClick() {
        ///显示菜单
//        let menuContrl = UIMenuController.showMenu(["编辑","删除"], [#selector(menuEditBtnClick),#selector(menuDeleteBtnClick)]);
//        menuContrl.setTargetRect(self.editeBtn.frame, in: self);
//        menuContrl.setMenuVisible(true, animated: true);
        UIMenuController.shared.setTargetRect(self.editeBtn.frame, in: self);
    }
    
    @objc private func menuEditBtnClick() {
        
    }
    @objc private func menuDeleteBtnClick() {
        
    }
    private lazy var editeBtn: UIButton = {
        let btn = UIButton();
        btn.setTitle("···", for: UIControl.State.normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold);
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal);
        btn.isHidden = true;
        
        return btn;
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension GroupDetailDynamicCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if cell.contentView.subviews.count == 0 {
            
            let imgV = UIImageView.init()
            imgV.contentScaleFactor = 1.0
            imgV.contentMode = UIView.ContentMode.scaleAspectFill
            //            imgV.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
            imgV.clipsToBounds = true;
            cell.contentView.addSubview(imgV)
            imgV.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            imgV.kf.setImage(with: URL.init(string: self.dataSources[indexPath.row]), placeholder: kPlaceholderImage, options: nil
                , progressBlock: nil, completionHandler: nil)
        } else {
            
            let view = cell.contentView.subviews.first as! UIImageView
            view.kf.setImage(with: URL.init(string: self.dataSources[indexPath.row]), placeholder: kPlaceholderImage, options: nil
                , progressBlock: nil, completionHandler: nil)
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 网图加载器，WebP加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let dataSource = JXRawImageDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return self.dataSources.count
        }, placeholder: { index -> UIImage? in
            let cell = collectionView.cellForItem(at: indexPath)
            let imageView = cell?.contentView.subviews.first as! UIImageView
            return imageView.image
        }, autoloadURLString: { index -> String? in
            return nil
        }) { index -> String? in
            return self.dataSources[index]
        }
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath)
            let imageView = cell?.contentView.subviews.first
            return imageView
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: indexPath.item)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wh = (collectionView.width - 12) / 3
        //        if indexPath.item == 0 {
        //            wh += 1
        //        }
        return CGSize.init(width: wh, height: wh)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
