//
//  WXApiManager.swift
//  华商领袖
//
//  Created by abc on 2019/4/2.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation
import UIKit
//微信appid
let WX_APPID="wx0a9ef3c6d7ed40c8"
//AppSecret
let SECRET="a20339600c4f819de8f27c73fe512965"
//微信
class WXApiManager:NSObject,WXApiDelegate {
    static let shared = WXApiManager()
    // 用于弹出警报视图，显示成功或失败的信息()
    private weak var sender:UIViewController! //(UIViewController)
    // 支付成功的闭包
    private var paySuccessClosure: ((_ returnKey: String) -> Void)?
    // 支付失败的闭包
    private var payFailClosure: (() -> Void)?
    //登录成功
    private var loginSuccessClosure:((_ code:String) -> Void)?
    //登录失败
    private var loginFailClosure:((_ reson: String) -> Void)?
    // 外部用这个方法调起微信支付
    func payAlertController(_ sender:UIViewController,
                            request:PayReq,
                            paySuccess: @escaping (String) -> Void,
                            payFail:@escaping () -> Void) {
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.paySuccessClosure = paySuccess
        self.payFailClosure = payFail
        if checkWXInstallAndSupport(){//检查用户是否安装微信
            WXApi.send(request)
        }
    }
    //外部用这个方法调起微信登录
    func login(_ sender:UIViewController,loginSuccess: @escaping ( _ code:String) -> Void,
               loginFail:@escaping (_ reson: String) -> Void){
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        if checkWXInstallAndSupport(){
            let req=SendAuthReq()
            req.scope="snsapi_userinfo"
            req.state="app"
            WXApi.send(req)
        }
    }
    
}
extension WXApiManager {
    func onResp(_ resp: BaseResp!) {
        if resp is PayResp {//支付
            let payresp = resp as! PayResp
            if resp.errCode == 0 {
                self.paySuccessClosure?(payresp.returnKey)
            }else{
//                WXSuccess           = 0,    /**< 成功    */
//                WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//                WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//                WXErrCodeSentFail   = -3,   /**< 发送失败    */
//                WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//                WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
//                let dict: [Int32: String] = [-1:"支付失败", -2:"您取消了支付", -3:"发送失败",-4:"授权失败",-5:"微信不支持"]
                UIAlertController.initAlertPromtVC(message: "支付失败！", confirmTitle: "知道了", confirmBlock: nil)
                self.payFailClosure?()
            }
        }else if resp is SendAuthResp {//登录结果
            let authResp = resp as! SendAuthResp
            var strMsg: String
            if authResp.errCode == 0 {
                strMsg="微信授权成功"
            } else{
                switch authResp.errCode{
                case -4:
                    strMsg="您拒绝使用微信登录"
                    break
                case -2:
                    strMsg="您取消了微信登录"
                    break
                default:
                    strMsg="微信登录失败"
                    break
                }
            }
            if authResp.errCode == 0 {
                self.loginSuccessClosure?(authResp.code!)
            } else {
                self.loginFailClosure?(strMsg)

            }

        }
    }
}

extension WXApiManager {
    // 检查用户是否已经安装微信并且有支付功能
    private func checkWXInstallAndSupport() -> Bool {
        if !WXApi.isWXAppInstalled() {
            ///这里的弹窗是我写的扩展方法
            UIAlertController.initAlertPromtVC(message: "微信未安装", confirmTitle: "知道了", confirmBlock: nil)
            return false
        }
        if !WXApi.isWXAppSupport() {
            ///这里的弹窗是我写的扩展方法
            UIAlertController.initAlertPromtVC(message: "当前微信版本不支持支付", confirmTitle: "知道了", confirmBlock: nil)
            return false
        }
        return true
    }
}
