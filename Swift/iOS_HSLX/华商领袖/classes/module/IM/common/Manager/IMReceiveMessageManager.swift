//
//  IMReciveMessageManager.swift
//  TencentIM
//
//  Created by hansen on 2019/4/29.
//  Copyright © 2019 hansen. All rights reserved.
//

import Foundation

class IMReceiveMessageManager : NSObject, TIMMessageListener{
    
    private override init() {
        super.init()
        TIMManager.sharedInstance()?.add(self)
    }
    
    static let shared = IMReceiveMessageManager()
    
    
    private func onNewMessage(_ msgs: [TIMMessage]!) {
        
        debugPrint("*************收到新消息: \(msgs ?? [])")
        
        
    }
    
    
    
}
