//
//  AdvertiseCollectionView.swift
//  华商领袖
//
//  Created by abc on 2019/3/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class AdvertiseLayout : UICollectionViewLayout {
    
    ///< 所有的cell的布局
    
    var attrsArray: Array<UICollectionViewLayoutAttributes>?
    ///每一列的高度
    var columnHeights: Array<CGFloat>?
    ///水平间隔
    var lineMargin: CGFloat = 10.0
    
    
    // collectionView 首次布局和之后重新布局的时候会调用
    // 并不是每次滑动都调用，只有在数据源变化的时候才调用
    override func prepare() {
        super.prepare()
        print(#function)
        self.attrsArray = []
        let count = self.collectionView!.numberOfItems(inSection: 0)
        if count > 0 {
            for i  in 0...count - 1 {
                let indexP = IndexPath.init(item: i, section: 0)
                self.attrsArray?.append(self.layoutAttributesForItem(at: indexP)!)
            }
        }
        
    }
    // 返回布局属性，一个UICollectionViewLayoutAttributes对象数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
        
    }
    // 计算布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(#function)

        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        let width: CGFloat = self.collectionView!.width - lineMargin * 2
        let height: CGFloat = self.self.collectionView!.height
        var originalX: CGFloat =  CGFloat(indexPath.item) * self.collectionView!.width + lineMargin
        if indexPath.item == 0 {
            originalX = lineMargin
        }
        
        attr.frame = CGRect.init(x: originalX, y: 0, width: width, height: height)
        
        
        attr.zIndex = indexPath.item
        
        return attr
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        print("\(#function) -------\(proposedContentOffset) ")
        return proposedContentOffset
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        print("\(#function) -------\(proposedContentOffset) ")
//
//        let index = proposedContentOffset.x / self.collectionView!.width
//
//        return CGPoint.init(x: proposedContentOffset.x + 10, y: proposedContentOffset.y)
//    }
    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
    
    // 返回collectionView的ContentSize
    override var collectionViewContentSize: CGSize {
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        if let lastAttr = self.attrsArray?.last {
            width = lastAttr.frame.origin.x + lastAttr.frame.size.width + lineMargin
            height = lastAttr.frame.origin.y + lastAttr.frame.size.height
        }
        if width == 0 {
            width = self.collectionView!.width
        }
        if height == 0 {
            height = self.collectionView!.height
        }
        
        return CGSize.init(width: width, height: height)
    }
    
    

}

