//
//  DYSliderHeadView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/5.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYSliderModel {
    
    var title: String?
    var isSelect: Bool?
    var index: Int?
    
    
}

class DYSliderHeadView: UIView {

    private var dataSources: [DYSliderModel] = []
    var selectIndexBlock: ((_ index: Int) -> Void)?
    var textColor: UIColor = UIColor.HWColorWithHexString(hex: "#333333");
    var selectColor = UIColor.blue;
    var currSelectIndex: Int = 0;
    var lineWidth:CGFloat = 30;
    
    var sliderPositionX: CGFloat = 0.0 {
        
        didSet {
            self.slider.frame = CGRect.init(x: self.sliderPositionX, y: self.slider.y, width: self.slider.width, height: self.slider.height)
        }
    
    }
    required init(titles: [String]) {
        super.init(frame: CGRect.zero)

        for item in titles {
            let index: Int = titles.index(of: item)!;
            let model = DYSliderModel.init();
            model.isSelect = index == 0 ? true : false;
            model.title = item;
            model.index = index;
            var width = item.getTexWidth(font: UIFont.systemFont(ofSize: 14), height: 30) + 20;
            if width < 60 {
                width  = 60;
            }
            self.widthCache[index] = width;
            self.dataSources.append(model);
        }
    }
    func updateSelectIndexFromOther(_ index: Int) {
        if index == self.currSelectIndex {
            return;
        }
        
        if index > self.dataSources.count {
            return;
        }
        self.collectionView.selectItem(at: IndexPath.init(item: index, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally);
        self.updateSlider(index: index);
        
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        if self.subviews.count == 0 {
            self.setupSubview()
        }
    }
    private func setupSubview() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.addSubview(self.slider)
        if self.dataSources.count > 0 {
            self.slider.isHidden = false;
            
            self.slider.frame = CGRect.init(x: (self.widthCache[0]! - lineWidth) * 0.5, y: self.height - 2, width: 30, height: 2);
        } else {
            self.slider.isHidden = true;
        }
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    func hideBottomLine() {
        self.lineView.isHidden = true;
    }
//   设置固有的size  在nnavigation push pop的时候回联通这个view带上动画
    override var intrinsicContentSize: CGSize {
        
        return self.bounds.size;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var widthCache: [Int : CGFloat]  = [:];
    private lazy var slider: UIView = {
        let view = UIView()
        view.backgroundColor = self.selectColor;
        view.bounds = CGRect.init(x: 0, y: 0, width: self.lineWidth, height: 2);
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init();
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
    
        let view = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout);
        view.backgroundColor = UIColor.white;
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
        view.showsHorizontalScrollIndicator = false;
        view.showsVerticalScrollIndicator = false;
        return view
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.5;
        return view
    }()
    private func updateSlider(index: Int) {
        
        let beforeCell = self.collectionView.cellForItem(at: IndexPath.init(item: self.currSelectIndex, section: 0));
        if beforeCell != nil {
            let beforeLabel =  beforeCell?.contentView.subviews.first as! UILabel;
            if self.currSelectIndex < index {
                self.collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionView.ScrollPosition.right, animated: true);
                
            } else {
                self.collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionView.ScrollPosition.left, animated: true);
                
            }
            let cell = collectionView.cellForItem(at: IndexPath.init(item: index, section: 0));
            let label = cell?.contentView.subviews.first as! UILabel;
            let model = self.dataSources[index];
            label.text = model.title;
            self.currSelectIndex = index;
            //        var x: CGFloat = CGFloat(index * self.widthCache[index]) + 15;
            var x: CGFloat = (self.widthCache[index]! - self.lineWidth)  * 0.5;
            if index > 0 {
                for i in 0...index-1 {
                    let width = self.widthCache[i];
                    x += width!;
                }
            }
            
            UIView.animate(withDuration: 0.25) {
                self.updateLabelStatus(isSelect: false, label: beforeLabel);
                self.updateLabelStatus(isSelect: true, label: label);
                self.slider.frame.origin.x = x;
            };
        }
        
        
    }
    
    private func updateLabelStatus(isSelect:Bool, label: UILabel) {
        let fontSize = label.font.pointSize;
        label.font = UIFont.systemFont(ofSize: isSelect ? fontSize + 2 : fontSize - 2);
        label.textColor = isSelect ? self.selectColor : self.textColor;
    }

    
   

}

extension DYSliderHeadView: UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSources.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label: UILabel?
        if cell.contentView.subviews.count == 0 {
            label = UILabel.init()
            label?.textColor = self.textColor;
            label?.font = UIFont.systemFont(ofSize: 14);
            label?.textAlignment = NSTextAlignment.center
            cell.contentView.addSubview(label!);
            label?.snp.makeConstraints { (make) in
                make.edges.equalToSuperview();
            }
            
        } else {
            label = cell.contentView.subviews.first as? UILabel
        }
        let model = self.dataSources[indexPath.item];
        if model.isSelect == true && indexPath.item == 0 {
            label?.font = UIFont.systemFont(ofSize: 16);
        }
//        label?.textColor = model.isSelect == true ? self.selectColor : UIColor.HWColorWithHexString(hex: "#333333");
        label?.text = self.dataSources[indexPath.item].title;

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateSlider(index: indexPath.item);
        if self.selectIndexBlock != nil {
            self.selectIndexBlock!(indexPath.item);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.widthCache[indexPath.item]!, height: collectionView.height);
    }
    
}
