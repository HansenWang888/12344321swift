//
//  SearchListCell.swift
//  华商领袖
//
//  Created by hansen on 2019/4/11.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class SearchListCell: BaseCell {
    @IBOutlet weak var avatarImgV: UIImageView!
    
    @IBOutlet weak var rightNeccessoryLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var model: AnyObject? {
        
        didSet {
            let m = self.model as! SearchLishtModel
            self.avatarImgV.kf.setImage(with: URL.init(string: m.groupUri ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
                self.avatarImgV.setCornerImage()
            }
            self.titleLabel.text = m.groupName
            self.subTitleLabel.text = "\(m.memberCount ?? 0)位成员"
            
            switch Int(m.distance ?? 0) {
            case 0...1000:
                self.rightNeccessoryLabel.text = String(m.distance ?? 0) + "m"
                break
            default:
               self.rightNeccessoryLabel.text = String(Int(m.distance ?? 0) / 1000) + "km"
                break
            }
            self.rightNeccessoryLabel.textColor = UIColor.HWColorWithHexString(hex: "#333333");
            if m.authStatus == 0 {
                self.rightNeccessoryLabel.text = "申请带审核";
                self.rightNeccessoryLabel.textColor = UIColor.red;
            }
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImgV.contentMode = .scaleAspectFill
        self.avatarImgV.clipsToBounds = true
        self.avatarImgV.backgroundColor = UIColor.clear
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
