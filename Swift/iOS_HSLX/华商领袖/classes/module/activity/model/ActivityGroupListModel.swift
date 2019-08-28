


// Created by hansen 
import Foundation 
import ObjectMapper 




class ActivityGroupListModel: BaseModel {



    /// 5 
    var brokerageCost: Double?
    /// 【赏花探花】常德桃花源踏春寻芳一日游 
    var activityTitle: String?
    /// 1 
    var type: Int?
    /// 0 
    var shares: Int?
    /// 达美D6区 
    var address: String?
    /// 30 
    var joinNumber: Int?
    /// 10 
    var vipCouponCost: Double?
    /// </div></div>
    var description: String?
    /// 华商领袖俱乐部 
    var coOrganizer: String?
    /// 0 
    var visits: Int?
    /// 中铁国旅旅行 
    var hostUnit: String?
    /// 1556323223000 
    var startTime: Double?
    /// 0 
    var status: Int?
    /// 199 
    var cost: Double?
    /// 15111125571 
    var phone: String?
    ///  
    var tags: String?
    /// 112.920129 
    var lng: Double?
    /// http://media.zqcw8888.com/chance_info/1554881936934802624.jpg 
    var urlPath: String?
    /// 1556357438000 
    var endTime: Double?
    /// 0 
    var hasJoinNumber: Int?
    /// 0 
    var isHot: Int?
    /// 1000002050407282 
    var id: String?
    /// 618 
    var userId: Int?
    /// *I99JR4s5Ru7CnHN 
    var typeId: String?
    /// 28.208029 
    var lat: Double?
    /// 指定地点集合 
    var detailAddress: String?

    required init?(map: Map) {
        super.init(map: map)
    }




    override func mapping(map: Map) {

        brokerageCost <- map["brokerageCost"]
        activityTitle <- map["activityTitle"]
        type <- map["type"]
        shares <- map["shares"]
        address <- map["address"]
        joinNumber <- map["joinNumber"]
        vipCouponCost <- map["vipCouponCost"]
        description <- map["description"]
        coOrganizer <- map["coOrganizer"]
        visits <- map["visits"]
        hostUnit <- map["hostUnit"]
        startTime <- map["startTime"]
        status <- map["status"]
        cost <- map["cost"]
        phone <- map["phone"]
        tags <- map["tags"]
        lng <- map["lng"]
        urlPath <- map["urlPath"]
        endTime <- map["endTime"]
        hasJoinNumber <- map["hasJoinNumber"]
        isHot <- map["isHot"]
        id <- map["id"]
        userId <- map["userId"]
        typeId <- map["typeId"]
        lat <- map["lat"]
        detailAddress <- map["detailAddress"]

  }




}
