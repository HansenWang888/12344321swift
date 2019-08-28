


// Created by hansen 
import Foundation 
import ObjectMapper 




class MyBankCardModel: Mappable {



    /// 1555116892000 
    var createTime: Int?
    ///  
    var prefecture: String?
    /// 男 
    var sex: String?
    /// 湖南省 
    var province: String?
    /// 湖南省临湘市 
    var area: String?
    /// 625 
    var userId: Int?
    /// 临湘市 
    var city: String?
    /// http://media.zqcw8888.com/bank_logo/CMB.png 
    var smallLogo: String?
    /// 430682 
    var addrCode: String?
    /// 汪宁 
    var name: String?
    /// 卡号
    var bankNo: String?
    /// 1990-06-01 
    var birthday: String?
    /// 3 
    var lastCode: String?
    /// 招商银行 
    var bank: String?
    /// 34 
    var id: Int?
    /// 借记卡 
    var cardType: String?
    /// 银联IC普卡 
    var cardName: String?
    /// 身份证号
    var idCard: String?

    required init?(map: Map) {}




    func mapping(map: Map) {




        createTime <- map["createTime"]
        prefecture <- map["prefecture"]
        sex <- map["sex"]
        province <- map["province"]
        area <- map["area"]
        userId <- map["userId"]
        city <- map["city"]
        smallLogo <- map["smallLogo"]
        addrCode <- map["addrCode"]
        name <- map["name"]
        bankNo <- map["bankNo"]
        birthday <- map["birthday"]
        lastCode <- map["lastCode"]
        bank <- map["bank"]
        id <- map["id"]
        cardType <- map["cardType"]
        cardName <- map["cardName"]
        idCard <- map["idCard"]

  }




}
