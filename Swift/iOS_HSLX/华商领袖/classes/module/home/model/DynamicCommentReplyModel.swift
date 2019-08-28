


// Created by hansen 
import Foundation 
import ObjectMapper 




class DynamicCommentReplyModel: Mappable {



    /// 14 
    var id: Int?
    /// 汪宁 
    var realName: String?
    /// 1558343391000 
    var replyTime: Int?
    /// 123456789 
    var content: String?
    /// 冬雪 
    var nickName: String?
    /// 625 
    var userId: Int?

    required init?(map: Map) {}




    func mapping(map: Map) {




        id <- map["id"]
        realName <- map["realName"]
        replyTime <- map["replyTime"]
        content <- map["content"]
        nickName <- map["nickName"]
        userId <- map["userId"]

  }




}