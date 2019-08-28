//
//  ActivityApplyVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/17.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class ActivityApplyVC: BaseVC {

  
    var model: ActivityGroupListModel?
    var finishedCallback: (() -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var commitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "报名信息确认";
        
        self.commitBtn.addTarget(self, action: #selector(commitBtnClick), for: UIControl.Event.touchUpInside)
        self.commitBtn.addRounded(radius: 5);
        self.titleLabel.text = self.model?.activityTitle;
        self.timeLabel.text = Date.getFormdateYMDHM(timeStamp: self.model?.startTime ?? 0) + "至" + Date.getFormdateYMDHM(timeStamp: self.model?.endTime ?? 0);
        self.priceLabel.text = "\(self.model?.cost ?? 0)元";
        self.nameLabel.text = LoginManager.manager.user?.nickName;
        self.textField.text = LoginManager.manager.user?.phone;
    }

    @objc private func commitBtnClick() {
        if self.model?.userId == LoginManager.manager.user?.userId {
            SVProgressHUD.showInfo(withStatus: "活动发起者，无需报名");
            return;
        }
        if self.model?.cost == 0 {
            //直接调用报名接口
            
            
            
            return;
        }
        
        
        let model = PayModel.init();
        model.giftBagId = 0;
        model.price = "\(self.model?.cost ?? 0.0)";
        model.productId = self.model?.id ?? "";
        model.type = 4;
        model.sid = 0;
        let vc = MyPaymentVC.init(model);
        vc.payFinished = {
            [weak self] in
            self?.finishedCallback?();
        }
        self.navigationController?.pushViewController(vc, animated: true);
    }
   

}
