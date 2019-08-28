


// Created by hansen 
import Foundation 
import ObjectMapper 




class GroupDetailDynaicModel: BaseModel {



    /// 0 
    var shares: Int?
    /// 0 
    var comments: Int?
    /// 4 
    var likes: Int?
    ///
    var content: String?
    /// 0 
    var latitude: Int?
    /// 38 
    var id: Int?
    /// http://media.zqcw8888.com/dynamic/1542716564922817045.jpg,http://media.zqcw8888.com/dynamic/1542716568079108800.jpg, 
    var picture: String?
    /// XWRv8fp79WfIW91g 
    var typeId: String?
    /// 8 
    var userId: Int?
    /// 0 
    var longitude: Int?
    /// 1554098144000 
    var updateTime: Int?
    /// 湘桂两会签协议 共推商会好未来 
    var title: String?
    /// NOT_READ 
    var isReadEnum: String?
    /// 1542716572000 
    var createTime: Int?
    /// 0 
    var isRead: Int?
    ///  
    var location: String?
    /// 1542901406000 
    var eventTime: Int?
    /// 2 
    var type: Int?

    required init?(map: Map) {
        super.init(map: map)
    }




    override func mapping(map: Map) {




        shares <- map["shares"]
        comments <- map["comments"]
        likes <- map["likes"]
        content <- map["content"]
        latitude <- map["latitude"]
        id <- map["id"]
        picture <- map["picture"]
        typeId <- map["typeId"]
        userId <- map["userId"]
        longitude <- map["longitude"]
        updateTime <- map["updateTime"]
        title <- map["title"]
        isReadEnum <- map["isReadEnum"]
        createTime <- map["createTime"]
        isRead <- map["isRead"]
        location <- map["location"]
        eventTime <- map["eventTime"]
        type <- map["type"]

  }

    func calculateCellHeight() -> CGFloat {
        
        var cellHeight:CGFloat = 50
        let titleTextHeight = self.title?.getTextHeigh(font: UIFont.systemFont(ofSize: 15), width: kScreenWidth - 30) ?? 0
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
