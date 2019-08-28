//
//  MyVipApplyModel.swift
//  华商领袖
//
//  Created by hansen on 2019/4/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import ObjectMapper

class MyVipApplyModel: Mappable {
    
    
    var description: String?
    var englishName: String?
    var name: String?
    var price: Double?
    var level: Int?
    var privilegeList: [[String: Any]]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        description <- map["description"]
        englishName <- map["englishName"]
        name <- map["name"]
        price <- map["price"]
        level <- map["level"]
        privilegeList <- map["privilegeList"]

    }

    
}
