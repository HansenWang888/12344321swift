//
//  DYNoDataView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/22.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYNoDataView: UIView {

    
    
    class func initTitle(_ title: String, image: UIImage) -> DYNoDataView {
        
        let view = DYNoDataView.init();
        view.setupSubView();
        view.describeLabel.text = title;
        view.imgView.image = image;
        return view;
        
    }
    class func  defaultView() -> DYNoDataView {
        
        let view = DYNoDataView.init();
        view.setupSubView()
        return view;
    }
    private func setupSubView() {
        self.addSubview(self.imgView);
        self.addSubview(self.describeLabel);
        self.imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(60);
            
        }
        self.describeLabel.snp.makeConstraints { (make) in
            make.left.right.centerX.equalToSuperview();
            make.top.equalTo(self.imgView).offset(8);
        }
    }
    
    
    private lazy var imgView: UIImageView = {
        let view = UIImageView();
        
        return view;
    }()

    private lazy var describeLabel: UILabel = {
        let label = UILabel();
        label.textAlignment = NSTextAlignment.center;
        label.textColor = kThemeTextColor;
        label.numberOfLines = 0;
        label.text = "暂无相关内容";
        return label;
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
