//
//  SearchLishtModel.swift
//  华商领袖
//
//  Created by hansen on 2019/4/11.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import ObjectMapper
//附近社群  华商领袖 商协会
class SearchLishtModel: BaseModel {
   
    

    
    /*
     "address": "达美苑",
     "authStatus": 2,
     "categoryType": 1,
     "description": "",
     "detailAddress": "达美D6区",
     "distance": 28,
     "groupId": "xb*R8n9tqV2MpNiY",
     "groupName": "羽毛球俱乐部",
     "groupUri": "http://media.zqcw8888.com/group_info/1552143326235897452.jpg",
     "latitude": 28.208196,
     "longitude": 112.920362,
     "memberCount": 1,
     "role": 0,
     "userId": 618
     */
    var address: String?
    var authStatus: Int?
    var categoryType: Int?
    var description: String?
    var detailAddress: String?
    var distance: Int?
    var groupId: String?
    var groupName: String?
    var groupUri: String?
    var latitude: Int?
    var longitude: Int?
    var memberCount: Int?
    var role: Int?
    var userId: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        address <- map["address"]
        authStatus <- map["authStatus"]
        categoryType <- map["categoryType"]
        description <- map["description"]
        detailAddress <- map["detailAddress"]
        groupName <- map["groupName"]
        groupUri <- map["groupUri"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        memberCount <- map["memberCount"]
        role <- map["role"]
        userId <- map["userId"]
        distance <- map["distance"]
        groupId <- map["groupId"]

    }

}
