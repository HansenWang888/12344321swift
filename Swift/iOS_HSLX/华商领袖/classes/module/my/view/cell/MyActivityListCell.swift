//
//  MyActivityListCell.swift
//  华商领袖
//
//  Created by hansen on 2019/5/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class MyActivityListCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!

    
    
    
    var model: ActivityGroupListModel? {
        
        didSet {
            
            self.imgView.kf.setImage(with: URL.init(string: self.model?.urlPath ?? ""),   placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, _, _, _) in
            }
            self.nameLabel.text = self.model?.activityTitle;
            self.timeLabel.text = Date.getFormdateYMDHM(timeStamp: self.model?.endTime ?? 0) + "结束";
            let dict = [0:"进行中", 1:"未知",2:"已结束"];
            self.statusLabel.text = dict[self.model?.status ?? 0];
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.addRounded(radius: 5);
        self.imgView.contentMode = .scaleAspectFit;
        self.imgView.clipsToBounds = true;
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
