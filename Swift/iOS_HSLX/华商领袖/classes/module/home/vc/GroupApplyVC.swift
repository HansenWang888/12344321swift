//
//  GroupApplyVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GroupApplyVC: UIViewController {

    
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    var groupid: String = "";
    var groupName: String = "";
    let disposed: DisposeBag = DisposeBag.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请加入";
        self.titleLabel.text = "申请加入" + self.groupName;
        self.applyBtn.addRounded(radius: 5);
        
        self.textfield.rx.text.orEmpty.subscribe { (text) in
            
            if self.textfield.text?.count ?? 0 > 0 {
                self.applyBtn.backgroundColor = kThemeColor
                self.applyBtn.isEnabled = true
                
            } else {
                self.applyBtn.isEnabled = false
                self.applyBtn.backgroundColor = UIColor.gray
            }
        }.disposed(by: disposed);
       
        // Do any additional setup after loading the view.
    }

    @IBAction func applyBtnClick(_ sender: Any) {
        SVProgressHUD.show(withStatus: nil);
        TIMGroupManager.sharedInstance().joinGroup(self.groupid, msg: self.textfield.text!, succ: {
            
            SVProgressHUD.showSuccess(withStatus: "申请成功，请等待群主验证...");
            self.navigationController?.popViewController(animated: true);
            
        }, fail: { (errcode, errmsg) in
            debugPrint("申请加入社群失败：" + errmsg!);
            SVProgressHUD.showError(withStatus: "申请提交失败");
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
