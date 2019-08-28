//
//  NearbyPersonModel.swift
//  华商领袖
//
//  Created by abc on 2019/4/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import ObjectMapper

class NearbyPersonModel: BaseModel {

    /*
     
     "address": "海南三亚",
     "areaCode": "",
     "businessScope": "",
     "companyName": "湖南英子文化有限公司",
     "cpShortName": "",
     "distance": 15,
     "expirationTime": null,
     "fStatus": 0,
     "headUrl": "http://thirdwx.qlogo.cn/mmopen/vi_32/UEXrgb8NI58ic7puWMyiavp3m92UMCibSD50XMRJ2TmOL1Sg2dE8T144axYq2hsBibGyFwfVJgFFfN0AHj8jdhQuiaA/132",
     "idCard": "",
     "isComplete": 1,
     "isInitiateVip": 0,
     "isRealName": 0,
     "loginCount": 13,
     "loginTime": 1546348789000,
     "nickName": "罗慧群",
     "openId": "",
     "phone": "18229862439",
     "postName": "讲师",
     "realName": "罗慧群",
     "referralCode": "",
     "sex": 1,
     "showState": 0,
     "unitId": 1056,
     "userId": 1346,
     "verified": 0,
     "vipLevel": 0,
     "webOpenId": "",
     "wechatNo": ""
     }
     */
    var address: String?
    var areaCode: String?
    var businessScope: String?
    var companyName: String?
    var cpShortName: String?
    var distance: Int?
    var expirationTime: Int?
    ///1 已关注 2 相互关注
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
