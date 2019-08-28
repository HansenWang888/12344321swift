//
//  HomeFriendInfoCell.swift
//  华商领袖
//
//  Created by abc on 2019/3/26.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class HomeFriendInfoCell: UITableViewCell {

    
    //MARK: public
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var vipImgV: UIImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var identifyImgV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dutyLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var timeAndDistance: UILabel!
    /**
     * 类型
     * @param 0 == 普通 1： 好友 按钮直接拨打电话
     *
     */
    var type: Int = 0;
    var model: NearbyPersonModel? {
        
        didSet {
            
            self.nameLabel.text = self.model?.nickName
            self.companyLabel.text = self.model!.companyName! + " · " + self.model!.postName!
            self.avatarImgV.kf.setImage(with: URL.init(string: self.model?.headUrl ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
                self.avatarImgV.setCornerImage()
            }
            var distance = "0m"
            switch Int(self.model?.distance ?? 0) {
            case 0...1000:
                distance = String(self.model?.distance ?? 0) + "m"
                break
            default:
                distance = String(Int(self.model?.distance ?? 0) / 1000) + "km"
                break
            }
            self.timeAndDistance.text = distance + " · " + Date.updateTimeToCurrennTime(timeStamp: Double(self.model!.loginTime ?? 0))
            self.vipImgV.isHidden = self.model?.vipLevel ?? 0 == 0 ? true : false
            self.sexImageView.image = self.model?.sex ?? 0 == 1 ? UIImage.init(named: "女") : UIImage.init(named: "男")
            self.identifyImgV.isHidden = self.model?.isRealName != 2 ? true : false
            if self.type == 1 {
                self.followBtn.setTitle("CALL", for: UIControl.State.normal);
            } else {
                self.updateFollowStatus()
            }
            
        }
    }
    
    var memberModel: GroupDetailMemberModel? {
        
        didSet {
            self.nameLabel.text = self.memberModel?.nickName
            self.companyLabel.text = self.memberModel!.companyName! + " · " + self.memberModel!.postName!
            self.avatarImgV.kf.setImage(with: URL.init(string: self.memberModel?.headUrl ?? ""), placeholder: kPlaceholderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
                self.avatarImgV.setCornerImage()
            }
            self.vipImgV.isHidden = self.memberModel?.vipLevel ?? 0 == 0 ? true : false
            self.sexImageView.image = self.memberModel?.sex ?? 0 == 1 ? UIImage.init(named: "女") : UIImage.init(named: "男")
            self.identifyImgV.isHidden = self.memberModel?.isRealName != 2 ? true : false
            self.followBtn.isEnabled = false
            self.followBtn.backgroundColor = kThemeColor
            self.followBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            let dict = [2: "群主",1: "管理员"]
            if self.memberModel?.role == 0 {
                self.followBtn.isHidden = true
            } else {
                self.followBtn.isHidden = false
                self.followBtn.setTitle(dict[self.memberModel?.role ?? 0], for: UIControl.State.normal)
            }
            self.followBtn.addBorder(width: 0)
            self.timeAndDistance.isHidden = true
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.followBtn.addTarget(self, action: #selector(followBtnClick), for: UIControl.Event.touchUpInside)
        self.followBtn.addRounded(radius: 3)
        self.followBtn.addBorder(width: 1, borderColor: UIColor.orange)
        self.followBtn.setTitle("+关注", for: UIControl.State.normal)
        self.followBtn.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        // Initialization code
//        self.avatarImgV.setCornerImage()
    }
    
    @objc func followBtnClick() {
        
        if type == 1 && self.model?.phone?.count ?? 0 > 0 {
            UIApplication.shared.openURL(URL.init(string: "tel://\(self.model!.phone!)")!);
            return;
        }
       
        CommonHandler.handleAttentionOrNot(targetID: self.model?.userId ?? 0, status: self.model?.fStatus ?? 0) { (result) in
            
            if result != nil {
                SVProgressHUD.dismiss()
                self.model?.fStatus = result
                self.updateFollowStatus()
            }
        }
    }
    
    private func updateFollowStatus() {
        switch self.model?.fStatus {
        case 1:
            self.followBtn.setTitle("已关注", for: UIControl.State.normal)
            break
        case 2:
            self.followBtn.setTitle("相互关注", for: UIControl.State.normal)
            break
        default:
            self.followBtn.setTitle("+关注", for: UIControl.State.normal)
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
