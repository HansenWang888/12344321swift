//
//  VerifyCodeVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/22.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class VerifyCodeVC: BaseVC {

   
    var phoneNumber: String = ""
    
    lazy var codeView: TDWVerifyCodeView = {
        let codeView = TDWVerifyCodeView.init(inputTextNum: 6)
        self.view.addSubview(codeView)
        return codeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "验证码登录"
        codeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.height.equalTo(35)
        }
        codeView.textFiled.becomeFirstResponder()
        
        // 监听验证码输入的过程
        codeView.textValueChange = { str in
            // 要做的事情
            print("当前s输入=== \(str)")
        }
//        self.phoneNumber = "13397511744"
        // 监听验证码输入完成
        codeView.inputFinish = {str in
            // 要做的事情
            SVProgressHUD.show(withStatus: "正在登录...")
            loginProvider.request(LoginNetwork.login(phone: self.phoneNumber, code: str), completion: { (result) in
                
                switch result {
                case let .success(response):
                    do {
                        var dict = try response.mapJSON() as! [String:Any]
                        let code = dict["code"] as! Int
                        if code == 200 {
                            let result = dict["result"]
                            var model: UserModel?
                            if result is NSNull {
                                SVProgressHUD.showInfo(withStatus: dict["msg"] as? String)
                            } else if result is [String : Any]  {
                                let dict: [String : Any] = result as! [String : Any]
                                model = UserModel.init(JSON: dict["user"] as! [String : Any])
                                LoginManager.manager.token = dict["token"] as? String ?? ""
                                LoginManager.manager.user = model
                                NotificationCenter.default.post(name: Notification.Name.nLogin_success, object: nil)
                            }
                            
                           
                        } else {
                            SVProgressHUD.showInfo(withStatus: dict["msg"] as? String)
                        }

                    } catch {
                        
                    }
                    break
                case .failure(_):
                    SVProgressHUD.showError(withStatus: "登录失败")
                    break
                }
                
            })
            
        }
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.text = "短信验证码已发送至  \(phoneNumber)"
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(codeView.snp_topMargin).offset(-50)
            make.centerX.equalTo(self.view)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
