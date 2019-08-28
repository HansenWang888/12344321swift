


// Created by hansen 
import Foundation 
import ObjectMapper 




class ArticleBrowseModel: Mappable {



    /// 141 
    var hits: Int?
    /// 1558431313000 
    var updateTime: Int?
    /// http://media.zqcw8888.com/images/article/bg_20181023154326.jpg 
    var urlPath: String?
    /// 1540624048000 
    var addTime: Int?
    /// 1 
    var onTop: Int?
    /// 1536822448000 
    var createTime: Double?
    /// 湖南正企创业服务有限公司 
    var title: String?
    /// 湖南正企创业服务有限公司 
    var author: String?
    /// 2 
    var articleId: Int?
    /// 湖南正企创业服务有限公司 
    var copyFrom: String?
    /// 1 
    var isElite: Int?
    /// &nbsp; &nbsp; &nbsp; &nbsp; 湖南正企创业服务有限公司是一家专业服务企业领袖的财务公司，由华商领袖俱乐部创始会员众筹成立，主要从事工商代办、代理记账、社保代办、许可证办理等相关服务业务。<div><br></div><div>
    var content: String?
    /// 1 
    var sortId: Int?

    required init?(map: Map) {}




    func mapping(map: Map) {




        hits <- map["hits"]
        updateTime <- map["updateTime"]
        urlPath <- map["urlPath"]
        addTime <- map["addTime"]
        onTop <- map["onTop"]
        createTime <- map["createTime"]
        title <- map["title"]
        author <- map["author"]
        articleId <- map["articleId"]
        copyFrom <- map["copyFrom"]
        isElite <- map["isElite"]
        content <- map["content"]
        sortId <- map["sortId"]

  }




}
