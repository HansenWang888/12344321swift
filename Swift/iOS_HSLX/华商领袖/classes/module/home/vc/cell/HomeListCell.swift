//
//  HomeListCell.swift
//  华商领袖
//
//  Created by abc on 2019/3/25.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit



enum CellType {
    
    case groupDynamic
    
    case nearbyDynamic
}

class HomeListCell: UITableViewCell {

    @IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var collectBtn: UIButton!
    
    var type : CellType = CellType.groupDynamic
    
    var model: HomeDynamicModel? {
        
        didSet {
            switch type {
            case .groupDynamic:
                self.dynamicContentView.type = .groupDynamic;
               
                break
            case .nearbyDynamic:
                self.dynamicContentView.type = .nearbyDynamic;
                break
            }
            self.dynamicContentView.model = self.model;
            
            self.collectBtn.setTitle(String.init(format: " %d", self.model?.likes ?? 0), for: UIControl.State.normal)
            if self.model?.likes == 0{
                self.collectBtn.setTitle(" 赞", for: UIControl.State.normal)
            }
            
            self.collectBtn.isSelected = self.model?.likeType == 1 ? true : false
            self.collectBtn.addTarget(self, action: #selector(likeBtnClick), for: UIControl.Event.touchUpInside)
        }
    }
    @objc private func likeBtnClick() {
        
        SVProgressHUD.show(withStatus: nil)
        NetWorkRequest(target: HomeNetwork.likeDynamic(status: self.collectBtn.isSelected ? 0 : 1, type: 1, typeId: self.model?.id ?? 0)) { (result) in
            
            switch result {
                
            case .successful:
                SVProgressHUD.dismiss()
                if self.collectBtn.isSelected {
//                    取消点赞
                    self.collectBtn.isSelected = false
                    self.model?.likeType = 0
                    self.model?.likes = (self.model?.likes ?? 1) - 1;
                    self.collectBtn.setTitle(" \(self.model?.likes ?? 0)", for: UIControl.State.normal)
                    if self.model?.likes == 0 {
                        self.collectBtn.setTitle(" 赞", for: UIControl.State.normal)
                    }
                    
                } else {
//                    点赞
                    self.collectBtn.isSelected = true
                    self.model?.likeType = 1
                    self.model?.likes = (self.model?.likes ?? 0) + 1;
                    self.collectBtn.setTitle(" \(self.model?.likes ?? 0)", for: UIControl.State.selected)
                }
               
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dynamicView.addSubview(self.dynamicContentView)
        self.dynamicContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            //转发
            
            break
        case 2:
            //评论
            
            break
        case 3:
            //点赞
            
            break
        default:
            break
        }
        
    }
    
    private var dynamicContentView: HomeDynamicContentView = HomeDynamicContentView.initGroupDynamicView()
}
