//
//  VerifyLoginVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/22.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
class VerifyLoginVC: BaseVC , NVActivityIndicatorViewable{

    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手机号码"
        self.setupSubView()
//        self.phoneTextfield.text = "13397511744"
        // Do any additional setup after loading the view.
    }
    
    private func setupSubView() {
        let leftView = UIView()
        let leftImg = UIImageView.init(image: UIImage(named: "手机号码"))
        leftView.bounds = CGRect.init(x: 0, y: 0, width: 40, height: 53)
        leftView.addSubview(leftImg)
        leftImg.frame = CGRect.init(x: 14, y: 35 * 0.5, width: 12, height: 18)
        self.phoneTextfield.leftViewMode = UITextField.ViewMode.always
        self.phoneTextfield.leftView = leftView
        self.phoneTextfield.keyboardType = UIKeyboardType.decimalPad
        self.nextBtn.layer.cornerRadius = 5
        self.nextBtn.layer.masksToBounds = true
        self.phoneTextfield.rx.text.orEmpty.asObservable().subscribe({text in
            
            if (text.element?.count)! > 0 {
                self.nextBtn.isEnabled = true
                self.nextBtn.backgroundColor = UIColor.HWColorWithHexString(hex: "#4876FF", alpha: 1.0)
            } else {
                self.nextBtn.isEnabled = false
                self.nextBtn.backgroundColor = UIColor.HWColorWithHexString(hex: "#CCCCCC", alpha: 1.0)
            }
            
        }).disposed(by: disposeBag)
        
        self.phoneTextfield.becomeFirstResponder()
    }
    
    
    

    @IBAction func nextBtnClick(_ sender: Any) {
        if self.phoneTextfield.text!.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入手机号码!")
            return
        }
        if self.phoneTextfield.text!.isTellephoneNumber() == false {
            SVProgressHUD.showInfo(withStatus: "请输入正确的手机号码!")

            return
        }
        SVProgressHUD.show(withStatus: "获取验证码...")
        NetworkManager.manager.getVerifyCode(phoneNumber: self.phoneTextfield.text!, success: { (res) in
            SVProgressHUD.dismiss()
            print("success === \(res)");
            if res["code"] as! Int == 200 {
                let vc = VerifyCodeVC()
                vc.phoneNumber = self.phoneTextfield.text!
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                SVProgressHUD.showInfo(withStatus: res["msg"] as? String)
            }
           
        }) { (error) in
            SVProgressHUD.showError(withStatus: "获取失败")
            print("获取验证码失败 \(error)")
        }
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.phoneTextfield.endEditing(true)
    }
}
