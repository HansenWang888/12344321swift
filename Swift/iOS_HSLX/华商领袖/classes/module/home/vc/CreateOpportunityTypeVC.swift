//
//  CreateOpportunityTypeVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/26.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class CreateOpportunityTypeVC: BaseVC {
    
    
    
    var selectedTypes: Array<Int> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布服务"
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.comfirBtn)
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.comfirBtn.snp.top).offset(-8)
        }
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.comfirBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-40)
        }

    }


    
    
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let cllv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cllv.register(CreateOpportunityTypeCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        cllv.backgroundColor = UIColor.white
        return cllv
    }()
    
    lazy var comfirBtn: UIButton = {
        
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("选好了，下一步", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.HWColorWithHexString(hex: "#4876FF")
        btn.addRounded(radius: 5)
        return btn
    }()
    
    lazy private var dataSources: Array<Dictionary<String, String>> = {
        
        return [
            ["title":"新产品","icon":"","isSelect":"false"],
            ["title":"新技术","icon":"","isSelect":"false"],
            ["title":"孵化加速","icon":"","isSelect":"false"],
            ["title":"融资","icon":"","isSelect":"false"],
            ["title":"投资","icon":"","isSelect":"false"],
            ["title":"销售渠道","icon":"","isSelect":"false"],
            ["title":"新媒体","icon":"","isSelect":"false"],
            ["title":"土地场地","icon":"","isSelect":"false"],
            ["title":"TOB服务","icon":"","isSelect":"false"],
            ["title":"招商","icon":"","isSelect":"false"],
            ["title":"招投标","icon":"","isSelect":"false"],
            ["title":"产业整合","icon":"","isSelect":"false"],
            ["title":"国际资源","icon":"","isSelect":"false"],
            ["title":"学习成长","icon":"","isSelect":"false"],
            ["title":"咨询","icon":"","isSelect":"false"],
            ["title":"其他","icon":"","isSelect":"false"],
        ]
        
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateOpportunityTypeVC: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CreateOpportunityTypeCell
        cell.contentBtn.setTitle(self.dataSources[indexPath.item]["title"], for: UIControl.State.normal)
//        cell.contentBtn.setImage(UIImage.init(named: self.dataSources[indexPath.item]["icon"]!), for: UIControl.State.normal)
        cell.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 255) / 255.0, green: 0.8, blue: 0.5, alpha: 1.0)
        cell.selectBtn.tag = indexPath.item
        let isSelect = self.dataSources[indexPath.item]["isSelect"]!
        cell.selectBtn.isSelected = Bool(isSelect)!
        
        return cell
    }
    
    
    
}

extension CreateOpportunityTypeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let wh = 70
        
        return CGSize.init(width: wh, height: wh)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let isSelect = self.dataSources[indexPath.item]["isSelect"]!
        self.dataSources[indexPath.item]["isSelect"] = Bool(isSelect)! ? "true" : "false"
        collectionView.reloadItems(at: [indexPath])
    }
    
}

class CreateOpportunityTypeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.contentBtn)
        self.contentView.addSubview(self.selectBtn)
        self.contentBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.selectBtn.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
//            make.size.equalTo(18)
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var contentBtn: WNButton = {
        
        let btn = WNButton()
        btn.customType = (1)
        btn.setTitleColor(UIColor.HWColorWithHexString(hex: "#11304C"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return btn
    }()
    
    lazy var selectBtn: UIButton = {
        
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("选中", for: UIControl.State.selected)
        btn.setTitle("未选中", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        
        return btn
    }()
    
}
