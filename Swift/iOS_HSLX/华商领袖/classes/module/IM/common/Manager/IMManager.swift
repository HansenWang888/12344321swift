//
//  IMManager.swift
//  TencentIM
//
//  Created by hansen on 2019/4/29.
//  Copyright © 2019 hansen. All rights reserved.
//

import Foundation

fileprivate let kIMAppid: Int32 = 1400156407//1400100372
fileprivate let kIMAccountType = "36862"//"29034"
class IMManager: NSObject  {
    
    private override init() {
        super.init()
    }
    static let shared = IMManager()
    
    static func initialIM() {
    
        let manager = TIMManager.sharedInstance()
        
        let config = TIMSdkConfig.init()
        config.sdkAppId = kIMAppid
        config.accountType = kIMAccountType
        config.connListener = shared
        config.disableLogPrint = true
//        config.logFunc = {
//            (level, content) in
//            debugPrint("IM 日志级别：\(level) \n IM 日志输出：\(content ?? "")")
//        }
        manager?.initSdk(config)
        
        let userConfig = TIMUserConfig.init()
        
        
        userConfig.userStatusListener = shared
        ///会话列表刷新
        userConfig.refreshListener = shared
        
        
        manager?.setUserConfig(userConfig)
        
        
        TUIKit.sharedInstance()?.initKit(Int(kIMAppid), accountType: kIMAccountType, with: (TUIKitConfig.defaultConfig() as! TUIKitConfig))
    }
    
    /**
     * 登录IM
     * @param userAccount 用户ID
     * @param token 私钥签名（调用后台接口获取）
     *
     */
    static func loginIM(userAccount: String, sign: String) {
        
        let loginParam = TIMLoginParam.init()
        loginParam.appidAt3rd = "\(kIMAppid)"
        loginParam.identifier = userAccount
        loginParam.userSig = sign
        TUIKit.sharedInstance()?.loginKit(userAccount, userSig: sign, succ: {
            
            debugPrint("IM  登录成功！")

        }, fail: { (errCode, errmsg) in
            debugPrint("IM 登录失败： code = \(errCode) 错误信息： \(errmsg ?? "")");

        });
       
    }
    /**
     * IM 退出登录
     *
     */
    static func logout() {
        
        TIMManager.sharedInstance()?.logout({
            debugPrint("IM 退出登录失败")
        }, fail: { (errCode, errmsg) in
            debugPrint("IM 退出登录失败： code = \(errCode) 错误信息： \(errmsg ?? "")");
        })
        
    }
    
  
    
    
    
    
    
    
   
    
}
//MARK: 用户在线状态通知
extension IMManager: TIMUserStatusListener {
    /**
     * 被踢下线
     *
     */
    func onForceOffline() {
        
        debugPrint("被踢下线")
    }
    
    /**
     *  断线重连失败
     */
    func onReConnFailed(_ code: Int32, err: String!) {
        
        debugPrint("断线重连失败")
    }
    /**
     *  用户登录的 userSig 过期（用户需要重新获取 userSig 后登录）
     */
    func onUserSigExpired() {
        
        debugPrint("用户登录的 userSig 过期（用户需要重新获取 userSig 后登录）")
    }
}


//MARK: 连接状态代理回调
extension IMManager: TIMConnListener {
    
    func onConnSucc() {
        debugPrint("IM 连接成功！！！")
    }
    
    func onConnFailed(_ code: Int32, err: String!) {
        debugPrint("IM 连接失败！！！")
        
    }
    
    func onDisconnect(_ code: Int32, err: String!) {
        debugPrint(" IM  断开连接， 正在重连------")
        
    }
    
    func onConnecting() {
        debugPrint(" IM 正在连接------")
        
    }
    
}

//MARK: 会话列表的刷新
extension IMManager : TIMRefreshListener {
    func onRefresh() {
        
        debugPrint("--------刷新全部会话列表-----------")
    }
    
    func onRefreshConversations(_ conversations: [Any]!) {
        
        debugPrint("--------刷新指定的会话列表-----------")
    }

}
