//
//  MyVipHeaderView.swift
//  华商领袖
//
//  Created by hansen on 2019/4/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class MyVipHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backgroudImgView: UIImageView!
    
    
    class func initHeaderView() -> MyVipHeaderView {
        let view = Bundle.main.loadNibNamed("MyVipHeaderView", owner: self, options: nil)?.first as! MyVipHeaderView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
