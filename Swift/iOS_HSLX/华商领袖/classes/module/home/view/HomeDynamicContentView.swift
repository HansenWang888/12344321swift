//
//  HomeDynamicContentView.swift
//  华商领袖
//
//  Created by abc on 2019/3/25.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import JXPhotoBrowser

enum DynamicType {
    
    case groupDynamic
    
    case nearbyDynamic
}

class HomeDynamicContentView: UIView {

    //MARK: public
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    
    
//    class func initNearbyDynamicView() -> HomeDynamicContentView {
//        let view = Bundle.main.loadNibNamed("HomeDynamicContentView", owner: nil, options: nil)?.first as! HomeDynamicContentView
//        view.organizationLabel.isHidden = true
//
//        return view
//    }
//
    class func initGroupDynamicView() -> HomeDynamicContentView {
        let view = Bundle.main.loadNibNamed("HomeDynamicContentView", owner: nil, options: nil)?.first as! HomeDynamicContentView
        
        return view
    }
    var type: DynamicType = .groupDynamic;
    var model: HomeDynamicModel? {
        
        didSet {
            switch type {
            case .groupDynamic:
                self.organizationLabel.text = self.model?.name
                self.nameLabel.isHidden = true
                self.subTitleLabel.isHidden = true
                break
            case .nearbyDynamic:
                self.nameLabel.text = self.model?.name
                self.subTitleLabel.text = self.model!.companyName! + " · " + self.model!.postName!
                self.organizationLabel.isHidden = true
                break
            }
            self.avatarImgView.kf.setImage(with: URL.init(string: self.model?.headUrl ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
                self.avatarImgView.setCornerImage()
            }
            self.contentLabel.text = self.model?.content
            self.timeLabel.text = Date.updateTimeToCurrennTime(timeStamp: self.model!.createTime!)
            
            switch Int(self.model?.distance ?? 0) {
            case 0...1000:
                self.distanceLabel.text = String(self.model?.distance ?? 0) + "m"
                
                break
            default:
                self.distanceLabel.text = String(Int(self.model?.distance ?? 0) / 1000) + "km"
                
                break
            }
            var array: [String] = self.model?.picture?.components(separatedBy: ",") ?? []
            if array.last?.count == 0 {
                array.removeLast()
            }
            self.sources = array;
            self.collectionView.reloadData();
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubview()
        self.avatarImgView.setCornerImage()
        self.avatarImgView.contentScaleFactor = 1.0
        self.avatarImgView.contentMode = UIView.ContentMode.scaleAspectFill
        self.avatarImgView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        self.avatarImgView.clipsToBounds = true;
//        self.collectionView.isScrollEnabled = true
        
    }
    //MARK: private
    
    private func setupSubview() {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
       
    
    }
    var sources: Array<String> = [] {
        
        didSet {
        
            self.collectionView.reloadData()
        }
    }
    

}

extension HomeDynamicContentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sources.count
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
            imgV.kf.setImage(with: URL.init(string: self.sources[indexPath.row]), placeholder: kPlaceholderImage, options: nil
                , progressBlock: nil, completionHandler: nil)
        } else {
            
            let view = cell.contentView.subviews.first as! UIImageView
            view.kf.setImage(with: URL.init(string: self.sources[indexPath.row]), placeholder: kPlaceholderImage, options: nil  
                , progressBlock: nil, completionHandler: nil)
        }
        
        return cell
   
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 网图加载器，WebP加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let dataSource = JXRawImageDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return self.sources.count
        }, placeholder: { index -> UIImage? in
            let cell = collectionView.cellForItem(at: indexPath)
            let imageView = cell?.contentView.subviews.first as! UIImageView
            return imageView.image
        }, autoloadURLString: { index -> String? in
            return nil
        }) { index -> String? in
            return self.sources[index]
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


class DynaicCollectionLayout: UICollectionViewLayout {
    
    
    
    
    
}
