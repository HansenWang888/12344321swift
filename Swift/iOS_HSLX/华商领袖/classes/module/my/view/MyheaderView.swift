//
//  MyheaderView.swift
//  华商领袖
//
//  Created by abc on 2019/3/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

/**
 * 我的首页的头部view
 * @param <#name#> <#desc#>
 *
 */
class MyheaderView: UIView {
    
    let imgView = UIImageView()
    let nameBtn = UIButton.init(type: UIButton.ButtonType.custom)
    let subTitle = UILabel()
    let nextBtn = UIButton.init(type: UIButton.ButtonType.custom)
    let authorizeBtn = UIButton.init(type: UIButton.ButtonType.custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
    }
    
    private func setupSubView (){
        
        addSubview(imgView)
        addSubview(nameBtn)
        addSubview(subTitle)
        addSubview(nextBtn)
        addSubview(authorizeBtn)
        imgView.snp.makeConstraints { (make) in
            make.size.equalTo(70)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        nameBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.top)
            make.left.equalTo(self.imgView.snp.right).offset(10)
        }
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameBtn.snp.left)
            make.top.equalTo(self.nameBtn.snp.bottom).offset(20)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(14)
            make.width.equalTo(14)
            make.height.equalTo(24)
        }
        authorizeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(78)
            make.height.equalTo(26)
            make.top.equalTo(self.nameBtn.snp.top)
            make.right.equalToSuperview().offset(-30)
        }
        let rightImgV = UIImageView.init(image: UIImage.init(named: "rightArrow"))
        self.addSubview(rightImgV)
        rightImgV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        imgView.backgroundColor = UIColor.orange
        nameBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        imgView.addRounded(radius: 35)
        nameBtn.titleLabel?.textColor = UIColor.HWColorWithHexString(hex: "#333333")
        nameBtn.setTitle("登录/注册", for: UIControl.State.normal)
        self.subTitle.text = "点击登录 享受更多精彩信息"
        self.subTitle.font = UIFont.systemFont(ofSize: 13)
        self.subTitle.textColor = UIColor.HWColorWithHexString(hex: "#333333")
        authorizeBtn.addRounded(radius: 13)
        authorizeBtn.backgroundColor = UIColor.orange
        self.authorizeBtn.isHidden = true
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
