//
//  GroupDynamicModel.swift
//  华商领袖
//
//  Created by abc on 2019/4/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import ObjectMapper

class HomeDynamicModel: BaseModel {
    
    /*
     {
     "comments": 0,
     "companyName": "",
     "content": "这里有你向往的世外桃源，园区依山傍水、风光秀美、田园如画。让我们一起带上自己的好心情，美美的开始我们的“花痴之旅”吧！",
     "cpShortName": "",
     "createTime": 1554285244000,
     "distance": 38,
     "headUrl": "http://media.zqcw8888.com/group_info/1545992761290562018.jpg",
     "id": 107,
     "likeType": 0,
     "likes": 1,
     "location": "",
     "name": "长沙休闲户外俱乐部",
     "picture": "http://media.zqcw8888.com/dynamic/1554285231311895214.jpg,http://media.zqcw8888.com/dynamic/1554285233062606485.jpeg,http://media.zqcw8888.com/dynamic/1554285234841766084.jpg,http://media.zqcw8888.com/dynamic/1554285238241836883.png,http://media.zqcw8888.com/dynamic/1554285239928921312.png,http://media.zqcw8888.com/dynamic/1554285241498311986.jpg,",
     "postName": "",
     "publisherId": "*I99JR4s5Ru7CnHN",
     "type": 1,
     "updateTime": 1554285284000
     }
     */
    
    var comments: Int?
    var companyName: String?
    var content: String?
    var cpShortName: String?
    var createTime: Double?
    var distance: Int?
    var headUrl: String?
    var id: Int?
    var likeType: Int?
    var likes: Int?
    var location: String?
    var name: String?
    var picture: String?
    var postName: String?
    var publisherId: String?
    var type: Int?
    var updateTime: Date?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        comments <- map["comments"]
        companyName <- map["companyName"]
        content <- map["content"]
        cpShortName <- map["cpShortName"]
        createTime <- map["createTime"]
        distance <- map["distance"]
        headUrl <- map["headUrl"]
        id <- map["id"]
        likeType <- map["likeType"]
        likes <- map["likes"]
        location <- map["location"]
        name <- map["name"]
        picture <- map["picture"]
        postName <- map["postName"]
        publisherId <- map["publisherId"]
        type <- map["type"]
        updateTime <- map["updateTime"]

    }
    func calculateCellHeight() -> CGFloat {
        
        var cellHeight:CGFloat = 50
        let titleTextHeight: CGFloat = 55
        let textHeight = self.content?.getTextHeigh(font: UIFont.systemFont(ofSize: 12), width: kScreenWidth - 30) ?? 0
        var pictureHeight: CGFloat = 0
        var array: [String] = self.picture?.components(separatedBy: ",") ?? []
        if array.last?.count == 0 {
            array.removeLast()
        }
        if array.count > 0 {
            let pictureWH = (kScreenWidth - 30 - 10) / 3
            let row = CGFloat(array.count) / 3
            switch row{
            case 0...1:
                pictureHeight = pictureWH
                break
            case 1...2:
                pictureHeight = pictureWH * 2 + 5
                break
            case 2...3:
                pictureHeight = pictureWH * 3 + 10
                break
            default:
                pictureHeight = 0
            }
            
        }
        cellHeight = textHeight + pictureHeight + cellHeight + titleTextHeight
        return cellHeight;
    }

}
