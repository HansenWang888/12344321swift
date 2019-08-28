//
//  LoginVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {

    class func initLoginVC () -> UIViewController {
        
        let nav = BaseNavigationVC.init(rootViewController: LoginVC())
        
        
        return nav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    @IBAction func wechatBtnClick(_ sender: Any) {
        
        WXApiManager.shared.login(self, loginSuccess: { (code) in
            //code 可以换取access_token
            self.weixinLogin(code: code)
            
        }) { reason in
            UIAlertController.initAlertPromtVC(message: reason, confirmTitle: "知道了", confirmBlock: nil)
        }
    }
    
    
    
    
    @IBAction func phoneBtnClick(_ sender: Any) {
        
        self.navigationController?.pushViewController(VerifyLoginVC(), animated: true)
        
    }
    
    private func weixinLogin(code: String) {
//        (let response as [String : Any])
        SVProgressHUD.show(withStatus: "登录中...")
        NetWorkRequest(target: LoginNetwork.getWXAccessToken(appid: WX_APPID, secret: SECRET, code: code), finished: { (result) in
            
            switch result {
                
            case .successful(let response):
                let dict = response as! [String : Any]
                
                let accessToken = dict["access_token"] as! String
                
                NetWorkRequest(target: LoginNetwork.wxUserInfo(token:accessToken , openID: dict["openid"]! as! String), finished: { (result) in
                    
                    switch result {
                        
                    case .successful(let response):
                        let dict = response as! [String : Any]
                        
                        NetWorkRequest(target: LoginNetwork.wxLogin(unionid: dict["unionid"]! as! String, sex: dict["sex"]! as! Int, token: accessToken, username: dict["nickname"] as! String, userIcon: dict["headimgurl"] as! String, openId: dict["openid"] as! String), finished: { (result) in
                            
                            switch result {
                                
                            case .successful(let response):
                                SVProgressHUD.dismiss()
                                let dict = response as! [String : Any]
                                let userDict = dict["user"] as? [String : Any]
                                LoginManager.manager.user = UserModel.init(JSON: userDict!)
                                LoginManager.manager.token = (dict["token"] as? String)!
                                NotificationCenter.default.post(name: Notification.Name.nLogin_success, object: nil)
//                                LoginManager.manager.loginIM();
                                break
                                
                            case .failure(let errmsg) :
                                SVProgressHUD.showError(withStatus: errmsg)
                                break
                            }
                        })
                        
                        break
                        
                    case .failure(let errmsg) :
                        SVProgressHUD.showError(withStatus: errmsg)
                        break
                    }
                })
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
            }
            
        })
        
    }
    
   

}
/*
 
 */
