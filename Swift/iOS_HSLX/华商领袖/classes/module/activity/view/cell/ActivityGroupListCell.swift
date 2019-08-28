//
//  ActivityGroupListCell.swift
//  华商领袖
//
//  Created by hansen on 2019/4/24.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class ActivityGroupListCell: BaseCell {

    @IBOutlet weak var headlineImgV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var sponsorLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
   
    
    
    override var model: AnyObject? {
        
        didSet {
            let model = self.model as? ActivityGroupListModel
            self.headlineImgV.kf.setImage(with: URL.init(string: model?.urlPath ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, _, _, _) in
                
            }
            self.nameLabel.text = model?.activityTitle
            self.addressLabel.text = model?.detailAddress
            self.sponsorLabel.text = "主办方：\(model?.hostUnit ?? "无")"
            self.timeLabel.text = Date.getFormdateYMDHM(timeStamp: Double(model?.startTime ?? 0))
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
