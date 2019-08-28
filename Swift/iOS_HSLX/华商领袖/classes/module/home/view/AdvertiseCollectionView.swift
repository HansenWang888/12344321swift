//
//  AdvertiseCollectionView.swift
//  华商领袖
//
//  Created by abc on 2019/3/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class AdvertiseCollectionView: UICollectionView {
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
//class AdvertiseLayout : UICollectionViewLayout {
//
//    ///< 所有的cell的布局
//
//    var attrsArray: Array<UICollectionViewLayoutAttributes>?
//    ///每一列的高度
//    var columnHeights: Array<CGFloat>?
//
//
//    // collectionView 首次布局和之后重新布局的时候会调用
//    // 并不是每次滑动都调用，只有在数据源变化的时候才调用
//    override func prepare() {
//        super.prepare()
//        let count = self.collectionView!.numberOfItems(inSection: 0)
//        for i  in 0...count {
//            let indexP = IndexPath.init(item: i, section: 0)
//            self.attrsArray?.append(self.layoutAttributesForItem(at: indexP)!)
//
//        }
//
//
//    }
//    // 返回布局属性，一个UICollectionViewLayoutAttributes对象数组
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//
//    }
//    // 计算布局属性
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }
//
//    // 返回collectionView的ContentSize
//    override var collectionViewContentSize: CGSize {
//        return super.collectionViewContentSize
//    }
//
//}

