


// Created by hansen 
import Foundation 
import ObjectMapper 




class BusinessDetailModel: Mappable {



    /// 2 
    var type: Int?
    /// 有限责任公司注册 
    var categoryName: String?
    /// 1 
    var parentCategoryType: Int?
    /// 100 
    var categoryType: Int?
    /// 0 
    var sortId: Int?
    /// 有限责任公司是指《中华人民共和国公司登记管理条例》规定登记注册，由五十个以下的股东出资设立，公司以全部资产对其债务承担责任的经济组织。 
    var categoryDesc: String?
    /// 1548403322000 
    var createTime: Int?
    /// 100 
    var floorPrice: Int?
    /// 1550822690000 
    var updateTime: Int?
    /// 17 
    var categoryId: Int?

    required init?(map: Map) {}




    func mapping(map: Map) {

        type <- map["type"]
        categoryName <- map["categoryName"]
        parentCategoryType <- map["parentCategoryType"]
        categoryType <- map["categoryType"]
        sortId <- map["sortId"]
        categoryDesc <- map["categoryDesc"]
        createTime <- map["createTime"]
        floorPrice <- map["floorPrice"]
        updateTime <- map["updateTime"]
        categoryId <- map["categoryId"]

    }

    func calculateCellHeight() -> CGFloat {
        
        var cellHeight: CGFloat = 60;
        
        let subTitleHeight = self.categoryDesc?.getTextHeigh(font: UIFont.systemFont(ofSize: 12), width: kScreenWidth * 0.7 - 16) ?? 0;
        cellHeight += subTitleHeight;
        
        if self.categoryDesc == nil && self.categoryName == nil {
            cellHeight = 140;
        }
        return CGFloat(cellHeight);
        
    }



}
