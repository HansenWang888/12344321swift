


// Created by hansen 
import Foundation 
import ObjectMapper 


class IMCommentLikeModel: BaseModel {



    /// 0 
    var isRealName: Int?
    /// 0 
    var sex: Int?
    /// 阿宁 
    var nickName: String?
    /// 1523 
    var userId: Int?
    /// 132 
    var dynamicId: Int?
    /// 1557997740000 
    var operateTime: Double?
    /// 哦破陪你磨合肉末肉伏地魔 
    var content: String?
    /// http://thirdwx.qlogo.cn/mmopen/vi_32/XAlUmrrZC3LKFQP1OAtjyxdtXXcApZU7lZ6ickCkutQkjtLHUlwKgTAic46Yj2cRaIicjoJfWTzNaGyNQrFG2ic8SA/132 
    var headUrl: String?
    /// 0 
    var isInitiateVip: Int?
    ///  
    var commentContext: String?
    /// 1 
    var type: Int?
    /// 阿宁 
    var realName: String?
    /// http://media.zqcw8888.com/dynamic/1557994168133711539.jpg,http://media.zqcw8888.com/dynamic/1557994168569820463.jpg,http://media.zqcw8888.com/dynamic/1557994168888538504.jpg, 
    var picture: String?
    /// 0 
    var vipLevel: Int?

    required init?(map: Map) {
        super.init(map: map);
        
    }
    
    override func mapping(map: Map) {




        isRealName <- map["isRealName"]
        sex <- map["sex"]
        nickName <- map["nickName"]
        userId <- map["userId"]
        dynamicId <- map["dynamicId"]
        operateTime <- map["operateTime"]
        content <- map["content"]
        headUrl <- map["headUrl"]
        isInitiateVip <- map["isInitiateVip"]
        commentContext <- map["commentContext"]
        type <- map["type"]
        realName <- map["realName"]
        picture <- map["picture"]
        vipLevel <- map["vipLevel"]

  }




}
