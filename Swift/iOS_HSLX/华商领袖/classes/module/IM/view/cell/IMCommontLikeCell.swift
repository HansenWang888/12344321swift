//
//  IMCommontLikeCell.swift
//  华商领袖
//
//  Created by hansen on 2019/5/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class IMCommontLikeCell: BaseCell {

   
    
    @IBOutlet weak var avatarImgV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var likeImgV: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
   
    @IBOutlet weak var rightImgV: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override var model: AnyObject? {
        
        didSet {
            let realModel = self.model as! IMCommentLikeModel;
            self.avatarImgV.kf.setImage(with: URL.init(string: realModel.headUrl ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, _, _, _) in
                self.avatarImgV.setCornerImage();
            }
            self.rightImgV.kf.setImage(with: URL.init(string: realModel.picture ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, _, _, _) in
                
            }
            self.nameLabel.text = realModel.realName?.count ?? 0 > 0 ? realModel.realName : realModel.nickName;
            if realModel.type == 1 {
                //文本动态
                self.commentLabel.isHidden = true;
                self.likeImgV.isHidden = false;
                self.rightLabel.isHidden = false;
                self.rightLabel.text = realModel.content;
                
            } else {
                //带图片动态
                self.commentLabel.isHidden = false;
                self.likeImgV.isHidden = true;
                self.rightLabel.isHidden = true;
                
            }
            self.commentLabel.text = realModel.commentContext;
            self.timeLabel.text = Date.getFormdateYMDHM(timeStamp: realModel.operateTime ?? 0);
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
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel();
        label.backgroundColor = UIColor.darkGray;
        label.textColor = UIColor.lightText;
        label.font = UIFont.systemFont(ofSize: 13);
        label.numberOfLines = 0;
        return label;
    }()

}
