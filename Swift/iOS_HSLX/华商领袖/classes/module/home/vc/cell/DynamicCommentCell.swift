//
//  DynamicCommentCell.swift
//  华商领袖
//
//  Created by hansen on 2019/5/20.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DynamicCommentCell: UITableViewCell {

    //MARK: public
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var vipImgV: UIImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var identifyImgV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    var model: DynamicCommentModel? {
        
        didSet {
            
            self.nameLabel.text = self.model?.nickName;
            self.commentLabel.text = self.model!.content;
            self.avatarImgV.kf.setImage(with: URL.init(string: self.model?.headUrl ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
                self.avatarImgV.setCornerImage()
            };
            
            self.vipImgV.isHidden = self.model?.vipLevel ?? 0 == 0 ? true : false
            self.sexImageView.image = self.model?.sex ?? 0 == 1 ? UIImage.init(named: "女") : UIImage.init(named: "男")
            self.identifyImgV.isHidden = self.model?.isRealName != 2 ? true : false
            
            self.timeLabel.text = Date.getFormdateYMDHM(timeStamp: self.model?.commentTime ?? 0);

            for item in self.stackView.arrangedSubviews {
                self.stackView.removeArrangedSubview(item);
            }
            for item in self.model?.replyList ?? [] {
                
                let view = DynamicCommentReplyView.init();
                view.name = (item.nickName ?? "") + "：";
                view.comment = item.content ?? "";
                view.sizeToFit();
                self.stackView.addArrangedSubview(view);
            }
            self.likeBtn.isSelected = self.model?.likeType == 1 ? true : false;
            self.likeBtn.setTitle(" \(self.model?.likeTotal ?? 0)", for: UIControl.State.normal)
            self.likeBtn.setTitle(" \(self.model?.likeTotal ?? 0)", for: UIControl.State.selected)
            self.stackView.backgroundColor = UIColor.groupTableViewBackground;

        }
    }
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    @IBAction func likeBtnClick(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: nil)
        NetWorkRequest(target: HomeNetwork.likeDynamic(status: self.likeBtn.isSelected ? 0 : 1, type: 2, typeId: self.model?.id ?? 0)) { (result) in
            
            switch result {
                
            case .successful:
                SVProgressHUD.dismiss()
                if self.likeBtn.isSelected {
                    //                    取消点赞
                    self.likeBtn.isSelected = false
                    self.model?.likeType = 0
                    self.model?.likeTotal = (self.model?.likeTotal ?? 1) - 1
                    self.likeBtn.setTitle(" \(self.model?.likeTotal ?? 0)", for: UIControl.State.normal)
                    if self.model?.likeTotal == 0 {
                        self.likeBtn.setTitle("", for: UIControl.State.normal)
                    }
                    
                } else {
                    //                    点赞
                    self.likeBtn.isSelected = true
                    self.model?.likeType = 1
                    self.model?.likeTotal = (self.model?.likeTotal ?? 0) + 1
                    self.likeBtn.setTitle(" \(self.model?.likeTotal ?? 0)", for: UIControl.State.selected)
                }
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


private class DynamicCommentReplyView: UIView {
    
    
    var name: String = "" {
    
        
        didSet {
            let attri = NSAttributedString.init(string: self.name, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.blue,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
                ]);
            self.contentLabel.attributedText = attri;
        }
    }
    
    var comment: String = "" {
        
        didSet {
            
            let nameAttri = self.contentLabel.attributedText;
            let fullAttri: NSMutableAttributedString = NSMutableAttributedString.init();
            if nameAttri?.length ?? 0 > 0 {
                
                fullAttri.append(nameAttri!);
                
            }
            let contentAttr = NSAttributedString.init(string: self.comment, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.HWColorWithHexString(hex: "#333333"),
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
                ]);
            fullAttri.append(contentAttr);
            self.contentLabel.attributedText = fullAttri;
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero);
        self.backgroundColor = .groupTableViewBackground;
        self.addSubview(self.contentLabel);
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview();
            
        }
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentLabel);
        }
        let lineView = UIView.init();
        lineView.backgroundColor = UIColor.gray;
        self.addSubview(lineView);
        lineView.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview();
            make.height.equalTo(0.5);
            make.left.equalToSuperview().offset(20);
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        
        return label;
    }()

    
    

    
    
}
