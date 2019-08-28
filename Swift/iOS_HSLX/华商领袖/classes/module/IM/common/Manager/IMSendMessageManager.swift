//
//  IMSendMessageManager.swift
//  TencentIM
//
//  Created by hansen on 2019/4/29.
//  Copyright © 2019 hansen. All rights reserved.
//

import Foundation


enum IMElementType {
    /**
     * 文本消息
     * @param text 内容
     *
     */
    case text(text: String)
}

enum IMSendResultType {
    //发送成功
    case successful
    //发送失败 返回消息内容
    case failure(errmsg: String)
}

typealias IMSendResultCallback = (IMSendResultType) -> Void

class IMSendMessageManager: NSObject {
    
   
    static let shared = IMSendMessageManager()
    
    /**
     * 发送单聊消息
     * @param receiveID 接收人
     * @param element 消息类型
     * @param result 发送结果回调
     *
     */
    static func sendSingleMessage(receiveID: String, element: IMElementType, result: @escaping IMSendResultCallback) {
        
        self.sendMessage(type: TIMConversationType.C2C, id: receiveID, element: element, result: result)
        
    }
    /**
     * 发送群聊消息
     * @param groupID 群组id
     * @param element 消息类型
     * @param result 发送结果回调
     *
     */
    static func sendGroupMessage(groupID: String, element: IMElementType, result: @escaping IMSendResultCallback) {
        
        self.sendMessage(type: TIMConversationType.GROUP, id: groupID, element: element, result: result)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: private
    private override init() {
        super.init()
    }
    
    
    private static func sendMessage(type: TIMConversationType, id: String, element: IMElementType, result: @escaping IMSendResultCallback) {
        
        let conversation = TIMManager.sharedInstance()?.getConversation(type, receiver: id)
        let message = self.generateMessage(element)
        if message.elemCount() == 0 {
            result(.failure(errmsg: "未知消息类型"))
            return
        }
        conversation?.send(message, succ: {
            result(.successful)
        }, fail: { (errcode, errmsg) in
            debugPrint("发送消息失败：code ==\(errcode) mmsg == \(errmsg ?? "未知")")
            result(.failure(errmsg: errmsg ?? "未知错误"))
        })
        
        
    }
    
    private static func generateMessage(_ element: IMElementType) -> TIMMessage {
    
        let  message = TIMMessage.init()
        switch element {
        case .text(let text):
            let elm = TIMTextElem.init()
            elm.text = text
            message.add(elm)
            break
        }
        
        return message
    }
}
