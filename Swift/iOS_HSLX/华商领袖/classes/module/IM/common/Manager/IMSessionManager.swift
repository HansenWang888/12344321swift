//
//  IMSessionManager.swift
//  TencentIM
//
//  Created by hansen on 2019/4/29.
//  Copyright © 2019 hansen. All rights reserved.
//

import UIKit

class IMSessionManager: NSObject {

    static let shared = IMSessionManager()
    private override init() {
        super.init()
    }
    ///缓存session模型
    var sessionList: [String : TConversationCellData] = [:]
    
    
    static func getSessionList() -> [TIMConversation]?{
        
        return TIMManager.sharedInstance()?.getConversationList() as? [TIMConversation];
    }
}
