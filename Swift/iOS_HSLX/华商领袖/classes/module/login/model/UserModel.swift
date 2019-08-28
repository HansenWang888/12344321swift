//
//  UserModel.swift
//  华商领袖
//
//  Created by abc on 2019/4/2.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation
import ObjectMapper
class UserModel : Mappable{
    var loginTime: Date?
    var loginCount: Int?
    var referralCode: String? ///用户推荐码
    private var _nickName: String?
    var nickName: String? {
        set {
            _nickName = newValue
        }
        get {
            if self.realName?.count ?? 0 > 0 {
                return self.realName
            }
            return _nickName
        }
    }
    var openId: String?
    var userId: Int?
    var vipLevel: Int?
    var webOpenId: String?
    var businessScope: String?
    var sex: Int?
    var isInitiateVip: Int?
    var realName: String?
    var cpShortName: String?
    var isRealName: Int?
    var unitId: Int?
    var verified: Int?
    var idCard: String?
    var fStatus: Int?
    var headUrl: String?
    var phone: String?
    var companyName: String?
    var distance: Int?
    var isComplete: Int?
    var showState: Int?
    var wechatNo: String?
    var areaCode: String?
    var expirationTime: Date?
    var address: String?
    var postName: String?
    
    init() {
        
    }
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        loginTime <- map["loginTime"]
        loginCount <- map["loginCount"]
        referralCode <- map["referralCode"]
        nickName <- map["nickName"]
        openId <- map["openId"]
        userId <- map["userId"]
        vipLevel <- map["vipLevel"]
        webOpenId <- map["webOpenId"]
        businessScope <- map["businessScope"]
        sex <- map["sex"]
        isInitiateVip <- map["isInitiateVip"]
        realName <- map["realName"]
        cpShortName <- map["cpShortName"]
        unitId <- map["unitId"]
        verified <- map["verified"]
        idCard <- map["idCard"]
        fStatus <- map["fStatus"]
        headUrl <- map["headUrl"]
        phone <- map["phone"]
        companyName <- map["companyName"]
        distance <- map["distance"]
        isComplete <- map["isComplete"]
        showState <- map["showState"]
        wechatNo <- map["wechatNo"]
        areaCode <- map["areaCode"]
        expirationTime <- map["expirationTime"]
        address <- map["address"]
        postName <- map["postName"]
        isRealName <- map["isRealName"]
    }

}
