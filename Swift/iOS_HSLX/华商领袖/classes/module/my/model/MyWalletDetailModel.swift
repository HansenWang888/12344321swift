


// Created by hansen 
import Foundation 
import ObjectMapper 




class MyWalletDetailModel: BaseModel {



    /// 0.01 
    var usable: Double?
    /// 1556348778000 
    var createTime: Double?
    /// 339 
    var id: Int?
    /// 338 
    var parentId: Int?
    /// 1 
    var operateNumber: Double?
    /// 0 
    var status: Int?
    /// 1 
    var walletType: Int?
    /// 11 
    var type: Int?
    /// 625 
    var userId: Int?
    /// 1 
    var operateType: Int?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        usable <- map["usable"]
        createTime <- map["createTime"]
        id <- map["id"]
        parentId <- map["parentId"]
        operateNumber <- map["operateNumber"]
        status <- map["status"]
        walletType <- map["walletType"]
        type <- map["type"]
        userId <- map["userId"]
        operateType <- map["operateType"]
  }




}
