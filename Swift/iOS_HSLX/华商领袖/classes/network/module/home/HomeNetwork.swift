//
//  HomeNetwork.swift
//  华商领袖
//
//  Created by abc on 2019/4/3.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation
import Moya

let homeProvider = MoyaProvider<HomeNetwork>()

public enum HomeNetwork{

/*
     http://www.zqcw8888.com/yhsclub/user/groupDynamics?size=10&type=0&page=0&lat=28.208308&lng=112.920105 组织动态
     
     http://www.zqcw8888.com/yhsclub/user/nearbyPersonageDynamic?size=10&page=0&lat=28.208308&lng=112.920105 附近动态
     
     http://www.zqcw8888.com/yhsclub/user/nearbyPeoples?size=10&page=0&lat=28.208308&lng=112.920105 附近人脉
     
     http://www.zqcw8888.com/yhsclub/user/userLocations?lat=28.208371&lng=112.920159 不知道  post
     
     http://www.zqcw8888.com/yhsclub/article?type=1 广告
     
     http://www.zqcw8888.com/yhsclub/im/accountImport?headUrl=http%3A%2F%2Fmedia.zqcw8888.com%2Fuser_info%2F1547652081193300380.jpg&nickName=%E5%86%AC%E9%9B%AA&userId=625  IM
     
     http://www.zqcw8888.com/yhsclub/im/userSig IM  估计是im用户登录
     
     */
    
    case getGroupDynamics(size: Int, type: Int, page: Int, lat:Double, lng: Double)
    
    case getNearbyPersonageDynamic(size: Int, page: Int, lat:Double, lng: Double)
    
    case getNearbyPeoples(size: Int, page: Int, lat:Double, lng: Double)
    
    case getAdvertise(type: Int)
    
    /**
     *
     * @param typeId 个人发布时为nil 群组动态时 传groupid
     *
     */
    case createPersonageDynamic(title: String?, picture: String?, location: String?, longtitude: Double?, latitude:Double?, id: Int, eventTime: Int, typeId: String?, content: String, type: Int)
    ///获取附近社群type = 1 华商领袖type = 3 商协会type = 2
    case getHomeGroupInfoes(size: Int, page: Int, lat:Double, lng: Double)
    ///联合创始人申请  category = 3 type = 0 创建社群 category = 1 type = 1
    /**
     * 联合创始人申请 创建社群 申请入驻
     * @param category  创始人申请 =3  创建社群 =1  申请入驻2
     * @param type 创建社群时的社区类型 同乡 = 1 行业 = 2 兴趣 = 3
     * @param areacode 当前为 城市code
     */
    case oranizationPersonApply(address: String, areaCode: String, businessLicense: String, categoryType: Int, detailAddress: String, groupName: String, groupUri: String, latitude: Double, longitude: Double, type:Int)
    
    
    /**
     * 给动态点赞
     * @param status 1 点赞 0 取消赞
     * @param type 1 == 动态点赞 2 == 评论点赞
     * @param typeId 动态ID

     */
    case likeDynamic(status: Int, type: Int, typeId: Int)
    
    /**
     * 搜索主页的社群 俱乐部和 商协会
     * @param authState 不知道 参考安卓 传2
     * @param type 社群 = 1 俱乐部 = 2 协会 = 3
     * @param key 搜索关键字
     */
    case searchGroupInfo(authState: Int, size: Int, page: Int, type: Int, key: String)

    /**
     * 获取社群详情的基本信息
     * @param name <#desc#>
     *
     */
    case getGroupDetaiInfo
    
    /**
     * 获取社群详情中的动态列表
     * @param pagesize
     * @param pageindex
     *
     */
    case getGroupDetailDynamicList(pageSize: Int, pageIndex: Int)
    
    /**
     * 获取社群详情中的成员列表
     * @param pagesize
     * @param pageindex
     * @param role 参照安卓传 4
     */
    case getGroupDetailMemberList(pageSize: Int, pageIndex: Int, role: Int)
    
    /**
     * 获取动态详情的评论列表
     * @param composeType 参照安卓 = 1
     *
     */
    case getDynamicCommentList(page:Int, size:Int,composeType: Int, composeId: Int)
    
    /**
     * 提交评论
     * @param type  = 1
     *
     */
    case commitComment(composeId: Int, composeType:Int, content:String)
    /**
     * 回复评论
     * @param replyId 动态id
     * @param replyType = 1
     *
     */
    case replyComment(commentId: Int, content: String, replyId: Int, replyType: Int, toUserId: Int);
    
    /**
     * 获取文章详情
     * @param <#name#> <#desc#>
     *
     */
    case getArticleInfo
    /**
     * 为文章增加浏览次数
     * @param <#name#> <#desc#>
     *
     */
    case articleBrowse(_ articleId: Int)
    
    /**
     * 获取创业服务中心资料
     *
     */
    case getBusinessServiceInfo
    
   
    
}
var groupInfosType: Int = 1;
var networkGroupID: String = "";
var networkArticleID: Int = 0;
extension HomeNetwork: TargetType {
   
    
    
    public var baseURL: URL {
        
        switch self {
       
        default:
            return URL(string: kBase_URL)!
        }
        
        
    }
    public var path: String {
        switch self {
        
            
        case .getGroupDynamics:
            
            return "/yhsclub/user/groupDynamics"
        case .getNearbyPersonageDynamic:
            
            return "/yhsclub/user/nearbyPersonageDynamic"

        case .getNearbyPeoples:
            
            return "/yhsclub/user/nearbyPeoples"

        case .getAdvertise:
            
            return "/yhsclub/article"
        case .createPersonageDynamic:
            return "/yhsclub/user/personageDynamic"
            
        case .getHomeGroupInfoes:
            
            return "/yhsclub/im/v1.0.1/groupInfos/type/\(groupInfosType)"
        case .oranizationPersonApply:
            return "/yhsclub/im/groupInfo"
        case .likeDynamic:
            return "/yhsclub/user/likes"
        case .searchGroupInfo:
            return "/yhsclub/im/groupInfos/search"
            
        case .getGroupDetaiInfo:
            
            return "/yhsclub/im/groupInfos/\(networkGroupID)"

        case .getGroupDetailDynamicList:
            
            return "/yhsclub/user/dynamics/typeId/\(networkGroupID)"
        case .getGroupDetailMemberList:
            return "/yhsclub/im/groupUsers/groupId/\(networkGroupID)"

        case .getDynamicCommentList:
            return "/yhsclub/user/comments"

        case .commitComment:
            return "/yhsclub/user/commments";
        case .replyComment:
            return "/yhsclub/user/replys";
        case .getArticleInfo:
            return "/yhsclub/article/\(networkArticleID)";
        case .articleBrowse(_):
            return "/yhsclub/article/hit";

        case .getBusinessServiceInfo:
            return "/yhsclub/product/productCategory/2";

        }

    }
    
    public var method: Moya.Method {
        switch self {
        case .createPersonageDynamic:
            return .post
        case .oranizationPersonApply:
            return .post
        case .likeDynamic:
                return .post
        case .commitComment:
            return .post
        case .replyComment:
            return .post;
        case .articleBrowse(_):
            return .put;
        default:
            return .get
        }
        
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        
        case .getGroupDynamics(let size, let type, let page, let lat, let lng):
            let parameters: [String : Any] = ["size":size,"type":type,"page":page,"lat":lat,"lng":lng]

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getNearbyPersonageDynamic(let size, let page, let lat, let lng):
            let parameters: [String : Any] = ["size":size,"page":page,"lat":lat,"lng":lng]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getNearbyPeoples(let size, let page, let lat, let lng):
            let parameters: [String : Any] = ["size":size,"page":page,"lat":lat,"lng":lng]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getAdvertise(let type):
            let parameters: [String : Any] = ["type":type]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .createPersonageDynamic(let title,let picture,let location, let longtitude, let latitude, let id, let eventTime, let typeId,let content,let type):
            let parameters: [String : Any] = [
                "title": title ?? "",
                "picture": picture ?? "",
                "location": location ?? "",
                "longtitude": longtitude  ?? 0,
                "latitude": latitude ?? 0,
                "id":id ,
                "eventTime": eventTime,
                "typeId": typeId ?? "",
                "content": content,
                "type":type
            ]

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .getHomeGroupInfoes(let size, let page, let lat, let lng):
            return .requestParameters(parameters: ["size":size,"page":page,"lat":lat,"lng":lng], encoding: URLEncoding.default)

        case .oranizationPersonApply(let address, let areaCode, let businessLicense, let categoryType, let detailAddress, let groupName, let groupUri, let latitude, let longitude, let type):
            
            return .requestParameters(parameters: ["address":address,"areaCode":areaCode,"businessLicense":businessLicense,"categoryType":categoryType,"detailAddress":detailAddress,"groupName":groupName,"groupUri":groupUri,"latitude":latitude,"longitude":longitude,"type":type,"placePicture": ""], encoding: JSONEncoding.default)

        case .likeDynamic(let status, let type, let typeId):
            return .requestParameters(parameters: ["status":status,"type":type,"typeId":typeId], encoding: URLEncoding.default)
        case .searchGroupInfo(let authState, let size, let page, let type, let key):
            return .requestParameters(parameters: ["authState":authState,"type":type,"size":size,"page":page,"key":key], encoding: URLEncoding.default)

        case .getGroupDetaiInfo:
            
            return .requestPlain
        case .getGroupDetailDynamicList(let pageSize, let pageIndex):
            return .requestParameters(parameters: ["size":pageSize,"page":pageIndex], encoding: URLEncoding.default)
        case .getGroupDetailMemberList(let pageSize, let pageIndex, let role):
            return .requestParameters(parameters: ["size":pageSize,"page":pageIndex,"role":role], encoding: URLEncoding.default)
        case .getDynamicCommentList(let page, let size, let composeType, let composeId):
            return .requestParameters(parameters: ["size":size,"page":page,"composeType":composeType,"composeId":composeId], encoding: URLEncoding.default);
        case .commitComment(let composeId, let composeType, let content):
            return .requestParameters(parameters: ["composeId":composeId,"composeType":composeType,"content":content], encoding: JSONEncoding.default);
        case .replyComment(let commentId, let content, let replyId, let replyType, let toUserId):
            return .requestParameters(parameters: ["commentId":commentId,"content":content,"replyId":replyId,"replyType":replyType,"toUserId":toUserId], encoding: JSONEncoding.default);

        case .getArticleInfo:
            return .requestPlain;
        case .articleBrowse(let articleId):
            return .requestParameters(parameters: ["articleId":articleId], encoding: URLEncoding.default);
        case .getBusinessServiceInfo:
            return .requestPlain;
       
        }
    }
    public var headers: [String : String]? {
        return ["authorization":LoginManager.manager.token]
        
    }
    
}


