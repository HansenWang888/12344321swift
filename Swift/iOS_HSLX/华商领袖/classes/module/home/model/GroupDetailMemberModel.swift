


// Created by hansen 
import Foundation 
import ObjectMapper 




class GroupDetailMemberModel: Mappable {



    /// 1544979743000 
    var addTime: Int?
    /// 1 
    var vipLevel: Int?
    /// 8 
    var userId: Int?
    /// XWRv8fp79WfIW91g 
    var groupId: String?
    /// 2 
    var role: Int?
    /// 0 
    var isInitiateVip: Int?
    /// 2 
    var isRealName: Int?
    /// 总经理 
    var postName: String?
    /// http://media.zqcw8888.com/user_info/1545828979970408682.jpg 
    var headUrl: String?
    /// 陈中原 
    var realName: String?
    ///  
    var cpShortName: String?
    /// 陈中原 
    var nickName: String?
    /// 湖南正企创业服务有限公司 
    var companyName: String?
    /// 0 
    var sex: Int?

    required init?(map: Map) {}




    func mapping(map: Map) {




        addTime <- map["addTime"]
        vipLevel <- map["vipLevel"]
        userId <- map["userId"]
        groupId <- map["groupId"]
        role <- map["role"]
        isInitiateVip <- map["isInitiateVip"]
        isRealName <- map["isRealName"]
        postName <- map["postName"]
        headUrl <- map["headUrl"]
        realName <- map["realName"]
        cpShortName <- map["cpShortName"]
        nickName <- map["nickName"]
        companyName <- map["companyName"]
        sex <- map["sex"]

  }
    
  




}
