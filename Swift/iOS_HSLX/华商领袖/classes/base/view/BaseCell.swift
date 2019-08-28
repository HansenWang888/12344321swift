//
//  BaseCell.swift
//  华商领袖
//
//  Created by hansen on 2019/4/24.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    
    var model: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
