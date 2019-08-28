//
//  CardManagerCell.swift
//  华商领袖
//
//  Created by abc on 2019/3/28.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class CardManagerCell: UITableViewCell {

    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var bankType: UILabel!
    
    @IBOutlet weak var bankNumber: UILabel!
    @IBOutlet weak var infoView: UIView!
    var model: MyBankCardModel? {
        
        didSet {
            self.bankName.text = self.model?.bank
            self.bankType.text = self.model?.cardType
            let number = self.model!.idCard!
            let cardText = number[0 ..< 4] + " **** **** " + number.substring(fromIndex: number.count - 4)
            self.bankNumber.text = cardText
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    self.infoView.addRounded(radius: 8)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
