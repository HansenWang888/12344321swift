//
//  CommonHandler.swift
//  华商领袖
//
//  Created by hansen on 2019/5/7.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//


/**
 * 处理一些公共业务
 *
 */
import Foundation

class CommonHandler {
    
    
    /**
     * 关注和取消用户关注
     * @param targetID 目标用户ID
     * &param status 1: 已关注 2： 相互关注
     *
     */
    static func handleAttentionOrNot(targetID: Int, status: Int, finished: @escaping (_ status: Int?) -> Void) {
        
        if status == 0 {
            kTargetUserID = targetID
            SVProgressHUD.show(withStatus: nil)
            NetWorkRequest(target: IMNetwork.attentionUser) { (result) in
                
                switch result {
                case .successful(let response):
                    let dict = response as! [String : Any]
                    let status = dict["fStatus"] as? Int
                    finished(status)
                    break
                    
                case .failure(let errmsg) :
                    finished(nil)
                    SVProgressHUD.showError(withStatus: errmsg)
                    break
                    
                }
            }
        } else {
            UIAlertController.showCustomAlertVC(message: "是否确定取消关注？", confirmTitle: "确定") { (_) in
                kTargetUserID = targetID
                SVProgressHUD.show(withStatus: nil)
                NetWorkRequest(target: IMNetwork.cancleAttentionUser) { (result) in
                    
                    switch result {
                    case .successful(let response):
                        let dict = response as! [String : Any]
                        let status = dict["fStatus"] as? Int
                        finished(status)
                        break
                        
                    case .failure(let errmsg) :
                        SVProgressHUD.showError(withStatus: errmsg)
                        break
                        
                    }
                }
            }
            
        }
        
        
    }
    
}
