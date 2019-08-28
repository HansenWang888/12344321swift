


// Created by hansen 
import Foundation 
import ObjectMapper 




class DynamicCommentModel: BaseModel {



    /// 113 
    var composeId: Int?
    /// 0 
    var vipLevel: Int?
    /// 625 
    var fromUserId: Int?
    /// 2 
    var isRealName: Int?
    /// 湖南英子文化有限公司 
    var companyName: String?
    /// 625 
    var userId: Int?
    /// 总经理 
    var postName: String?
    /// http://media.zqcw8888.com/user_info/1547652081193300380.jpg 
    var headUrl: String?
    /// 汪宁 
    var realName: String?
    /// 13397511744 
    var phone: String?
    /// 1 
    var sex: Int?
    /// 真好玩 
    var content: String?
    /// 0 
    var likeType: Int?
    /// 0 
    var likeTotal: Int?
    /// 56 
    var id: Int?
    /// 1 
    var composeType: Int?
    /// 冬雪 
    var nickName: String?
    /// 0 
    var isInitiateVip: Int?
    /// 1558343144000 
    var commentTime: Double?
    /// (]
    var replyList: Array<DynamicCommentModel>?

    required init?(map: Map) {super.init(map: map)}




    override func mapping(map: Map) {

        composeId <- map["composeId"]
        vipLevel <- map["vipLevel"]
        fromUserId <- map["fromUserId"]
        isRealName <- map["isRealName"]
        companyName <- map["companyName"]
        userId <- map["userId"]
        postName <- map["postName"]
        headUrl <- map["headUrl"]
        realName <- map["realName"]
        phone <- map["phone"]
        sex <- map["sex"]
        content <- map["content"]
        likeType <- map["likeType"]
        likeTotal <- map["likeTotal"]
        id <- map["id"]
        composeType <- map["composeType"]
        nickName <- map["nickName"]
        isInitiateVip <- map["isInitiateVip"]
        commentTime <- map["commentTime"]
        replyList <- map["replyList"]

  }

    
    
    func calculateCellHeight() -> CGFloat {
        
        var cellHeight: CGFloat = 80;
        
        let contentHeight = self.content?.getTextHeigh(font: UIFont.systemFont(ofSize: 15), width: kScreenWidth - 92);
        
        var replyHeight:CGFloat = 20;
        
        for item in self.replyList ?? [] {
            
            let replyStr = (item.nickName ?? "") + (item.content ?? "");
            let rHeight = replyStr.getTextHeigh(font: UIFont.systemFont(ofSize: 15), width: kScreenWidth - 92) + 5;
            replyHeight += rHeight;
        }
    
        cellHeight += contentHeight! + replyHeight;
        return  cellHeight;
    
    }

}
