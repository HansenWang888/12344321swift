//
//  PesonInfoModel.swift
//  华商领袖
//
//  Created by hansen on 2019/5/5.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import ObjectMapper

class PersonInfoModel: BaseModel {

    var address: String?
    var areaCode: String?
    var businessScope: String?
    var companyName: String?
    var cpShortName: String?
    var distance: Int?
    var expirationTime: Int?
    var fStatus: Int?
    var headUrl: String?
    var idCard: String?
    var isComplete: Int?
    var isInitiateVip: Int?
    var isRealName: Int?
    var loginCount: Int?
    var loginTime: Int?
    var nickName: String?
    var openId: String?
    var phone: String?
    var postName: String?
    var realName: String?
    var referralCode: String?
    var sex: Int?
    var showState: Int?
    var unitId: Int?
    var userId: Int?
    var verified: Int?
    var vipLevel: Int?
    var webOpenId: String?
    var wechatNo: String?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        address <- map["address"]
        areaCode <- map["areaCode"]
        businessScope <- map["businessScope"]
        companyName <- map["companyName"]
        cpShortName <- map["cpShortName"]
        distance <- map["distance"]
        expirationTime <- map["expirationTime"]
        fStatus <- map["fStatus"]
        headUrl <- map["headUrl"]
        idCard <- map["idCard"]
        isComplete <- map["isComplete"]
        isInitiateVip <- map["addrisInitiateVipess"]
        isRealName <- map["isRealName"]
        loginCount <- map["loginCount"]
        loginTime <- map["loginTime"]
        nickName <- map["nickName"]
        openId <- map["openId"]
        phone <- map["phone"]
        postName <- map["postName"]
        realName <- map["realName"]
        referralCode <- map["referralCode"]
        sex <- map["sex"]
        showState <- map["showState"]
        unitId <- map["unitId"]
        userId <- map["userId"]
        verified <- map["verified"]
        vipLevel <- map["vipLevel"]
        webOpenId <- map["webOpenId"]
        wechatNo <- map["wechatNo"]
        
        
    }
    
    
}
