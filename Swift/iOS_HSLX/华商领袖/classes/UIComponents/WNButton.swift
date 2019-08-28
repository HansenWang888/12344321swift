//
//  WNButton.swift
//  华商领袖
//
//  Created by abc on 2019/3/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class WNButton: UIButton {
    ///1 图片在上 2 图片在右 3 图片文字都居中
    @objc var customType: NSNumber?
    
    @objc var margin: CGFloat = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if customType?.intValue == 1 {
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: (titleLabel?.height)! + 1, right: -((titleLabel?.width)! + 1))
            self.titleEdgeInsets = UIEdgeInsets.init(top: (imageView?.height)! + margin, left: -((imageView?.width)! + 1), bottom: 0, right: 0)
        } else if customType?.intValue == 2 {
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: titleLabel!.width + margin, bottom: 0, right: -((titleLabel?.width)! + 1))
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -((imageView?.width)! + 1), bottom: 0, right: imageView!.width + 1)
        } else if customType?.intValue == 3 {
            self.imageView?.frame = self.bounds
            self.titleLabel?.frame = self.imageView!.frame
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.bringSubviewToFront(self.titleLabel!)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
