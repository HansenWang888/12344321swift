


// Created by hansen 
import Foundation 
import ObjectMapper 




class BusinessListModel: Mappable {



    /// 1 
    var categoryId: Int?
    /// 0 
    var sortId: Int?
    /// 工商注册 
    var categoryName: String?
    /// 1 
    var categoryType: Int?
    /// (
    var categoryList: [BusinessDetailModel]?
    
    var isSelected: Bool = false;

    required init?(map: Map) {}




    func mapping(map: Map) {




        categoryId <- map["categoryId"]
        sortId <- map["sortId"]
        categoryName <- map["categoryName"]
        categoryType <- map["categoryType"]
        categoryList <- map["categoryList"]

  }




}
