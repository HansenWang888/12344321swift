//
//  MyPreparePayModel.swift
//  华商领袖
//
//  Created by hansen on 2019/4/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import ObjectMapper

class MyPreparePayModel: Mappable {

    
    var appid: String?
    var noncestr: String?
    var outTradeNo: String?
    var package: String?
    var partnerid: String?
    var prepayid: String?
    var sign: String?
    var timestamp: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        appid <- map["appid"]
        outTradeNo <- map["outTradeNo"]
        package <- map["package"]
        partnerid <- map["partnerid"]
        prepayid <- map["prepayid"]
        sign <- map["sign"]
        noncestr <- map["noncestr"]
        timestamp <- map["timestamp"]

    }
}
