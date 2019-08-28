//
//  LoginManager.swift
//  华商领袖
//
//  Created by abc on 2019/3/22.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation

class LoginManager {
    
    var isLogin: Bool?
    
    var user: UserModel? {
        
        didSet {
            if user!.userId != nil {
                let dict = user?.toJSON()
                UserDefaults.standard.set(dict, forKey: k_user_key)
            }
        }
    }
    
    var token: String = "" {
        
        didSet {
            
            UserDefaults.standard.set(token, forKey: k_token_key)

        }
    }
    var IMSign: String = ""
    
    var wx_accessToken: String?
    
    func getUserData() -> Bool {
        let dict = UserDefaults.standard.object(forKey: k_user_key)
        if dict is [String: Any]{
            self.user = UserModel.init(JSON: dict as! [String : Any] )
            if (self.token.count > 0) {
                NetWorkRequest(target: LoginNetwork.getUserInfo) { (result) in
                    switch result {
                        
                    case .successful(let response):
                        self.user = UserModel.init(JSON: response as![String : Any] )
                        NotificationCenter.default.post(name: Notification.Name.nUpdate_userInfo,object: nil)
                        //IM 登录。。
                        self.loginIM()
                        break
                        
                    case .failure(let errmsg):
                        SVProgressHUD.showError(withStatus: errmsg)
                        NotificationCenter.default.post(name: Notification.Name.nLogin_exit, object: nil)
                        break
                        
                    }
                }
              
            }
            
            return true

        } else {
            return false

        }
        
    }
    
    private init() {
        isLogin = false
        self.token = UserDefaults.standard.value(forKey: k_token_key) as? String ?? ""
    }
    
    func loginIM() {
        
        NetWorkRequest(target: IMNetwork.registerIM(headUrl: self.user?.headUrl ?? "", nickName: self.user?.nickName ?? "", userId: self.user?.userId ?? 0)) { (result) in
            
            switch result {
            case .successful:
                NetWorkRequest(target: IMNetwork.getIMUserSign, finished: { (result) in
                    
                    switch result {
                    case .successful(let response):
                        self.IMSign = response as! String
                        IMManager.loginIM(userAccount: "\(self.user?.userId ?? 0)", sign: self.IMSign)
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
            
        }
        
    }
    
    static let manager = LoginManager()
    
    
    private let k_user_key: String = "k_user_key"
    
    private let k_token_key = "k_token_key"
    
}

