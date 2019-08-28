//
//  HomeAdvertiseViewCell.swift
//  华商领袖
//
//  Created by abc on 2019/4/4.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class HomeAdvertiseViewCell: UICollectionViewCell {


    
    @IBOutlet weak var imageView: UIImageView!
    var model: HomeAdvertiseModel = HomeAdvertiseModel.init(JSON: [:])! {
        
        didSet {
            
            self.imageView.kf.setImage(with: URL.init(string: model.urlPath!))
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRounded(radius: 8)

        // Initialization code
    }

}
