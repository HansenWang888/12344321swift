


// Created by hansen 
import Foundation
import ObjectMapper


class GroupDetaiInfoModel: Mappable {



    var detailAddress: String?
    var applyName: String?
    var placePicture: String?
    var description: String?
    var memberCount: Int?
    var applyPhone: String?
    var parentId: String?
    var creatorId: Int?
    var authStatus: Int?
    var longitude: Double?
    var businessLicense: String?
    var type: Int?
    var backPhoto: String?
    var message: String?
    var groupName: String?
    var createTime: Int?
    var frontPhoto: String?
    var address: String?
    var areaCode: Int?
    var groupUri: String?
    var categoryType: Int?
    var groupId: String?
    var latitude: Double?
    var userId: Int?
    var applyIdcard: String?

    required init?(map: Map) {}




    func mapping(map: Map) {

        detailAddress <- map["detailAddress"]
        applyName <- map["applyName"]
        placePicture <- map["placePicture"]
        description <- map["description"]
        memberCount <- map["memberCount"]
        applyPhone <- map["applyPhone"]
        parentId <- map["parentId"]
        creatorId <- map["creatorId"]
        authStatus <- map["authStatus"]
        longitude <- map["longitude"]
        businessLicense <- map["businessLicense"]
        type <- map["type"]
        backPhoto <- map["backPhoto"]
        message <- map["message"]
        groupName <- map["groupName"]
        createTime <- map["createTime"]
        frontPhoto <- map["frontPhoto"]
        address <- map["address"]
        areaCode <- map["areaCode"]
        groupUri <- map["groupUri"]
        categoryType <- map["categoryType"]
        groupId <- map["groupId"]
        latitude <- map["latitude"]
        userId <- map["userId"]
        applyIdcard <- map["applyIdcard"]

    }




}
