//
//  HomeAdvertiseModel.swift
//  华商领袖
//
//  Created by abc on 2019/4/4.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import ObjectMapper

class HomeAdvertiseModel: Mappable {
    
   /* {
    "addTime": 1540626120000,
    "articleId": 1,
    "author": "陈中原",
    "content": "<p style=\"text-indent:2em\">各位商业领袖大家好，在众人共同努力和支持下，《华商领袖》APP正式上线并开始投入运营。</p>\r\n<p style=\"text-indent:2em\">《华商领袖俱乐部》是一个聚集了众多企业法人，总经理，副总经理，个体工商老板，公司高管，投资家，经济学家等领袖人才的商业信息交互和资源共享平台。现有加盟俱乐部分部十个，创始会员500多名，会员全部实名制，并为后期加入的新会员设立了相对严格的会员认证和会费门槛，以保障后续会员的“纯粹性”和“可信度”。</p>\r\n<p style=\"text-indent:2em\">各个俱乐部分部每星期会举办固定时间的会员见面会，总部也会不定期举办管理主题沙龙活动，户外休闲交友活动，还有中大型公开课活动。会员可以通过线上线下互动交流，有效快捷的实现信息互通和资源共享。</p>\r\n<p style=\"text-indent:2em\">为扩大俱乐部的规模和实力，《华商领袖俱乐部》还将持续面向社会招募俱乐部分部，分部负责人可以通过平台整合身边的人脉，为自己带来更多更有效的商业资源，具体申请条件请联系平台创始人。</p>\r\n<p style=\"text-indent:2em\">在当今实体萧条，利润透明，人工成本高，获客成本高的经济环境下，企业的生存环境也越发艰难，加强商业领袖之间的交流，促进领袖之间的资源共享，信息共享，经验碰撞，提升领袖影响力.策划力.整合力，是华商领袖俱乐部成立的宗旨，也是每个企业领袖增强自身竞争力的必修课。</p>\r\n<p style=\"text-indent:2em\">物以类聚，人以群分，华商领袖俱乐部创始人在此欢迎敢于创新，敢于冒险，敢于合作的商业领袖倾情加盟。</p>",
    "copyFrom": "华商领袖",
    "createTime": 1540280533000,
    "hits": 90,
    "isElite": 1,
    "onTop": 1,
    "sortId": 1,
    "title": "华商领袖俱乐部",
    "updateTime": 1544989321000,
    "urlPath": "http://media.zqcw8888.com/images/article/bg_20181023154231.jpg"
    }
 */
    
    var addTime:Int?
    var articleId:Int?
    var author:String?

    var content:String?
    var copyFrom:String?
    var createTime:Int?
    var hits:Int?
    var isElite:Int?
    var onTop:Int?
    var sortId:Int?
    var title:String?
    var updateTime:Int?
    var urlPath:String?

    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        addTime <- map["addTime"]
        articleId <- map["articleId"]
        author <- map["author"]
        content <- map["content"]
        copyFrom <- map["copyFrom"]
        createTime <- map["createTime"]
        hits <- map["hits"]
        isElite <- map["isElite"]
        onTop <- map["onTop"]
        sortId <- map["sortId"]

        title <- map["title"]
        updateTime <- map["updateTime"]
        urlPath <- map["urlPath"]

    }
    

    
}
