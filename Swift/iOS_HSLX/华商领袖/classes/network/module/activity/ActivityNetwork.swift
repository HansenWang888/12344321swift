//
//  ActivityNetwork.swift
//  华商领袖
//
//  Created by hansen on 2019/4/25.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Moya

public enum ActivityNetwork {
    
    /**
     * 获取活动列表
     * @param type 0:社群  1 ： 个人
     *
     */
    case getGroupActivityList(type: Int, pageSize: Int, pageIndex: Int)
    
    /**
     * 活动搜索列表
     * @param type 搜索关键字
     *
     */
    case searchGroupActivityList(key: String, pageSize: Int, pageIndex: Int)
    
    /**
     * 查看活动的详情
     * 活动ID拼接到相对路径后面
     *
     */
    case getActivityDetail
    
    /**
     * 查看活动参与人数列表
     * 活动ID拼接到相对路径后面
     *
     */
    case getActivityJoinList(page: Int, size: Int)
    /**
     * 记录活动详情的记录
     *
     *
     */
    case recordActivityBrowse
    
    /**
     * 创建活动 重新修改
     * @param id 传id修改时候用
     *
     */
    
    case createActitivity(address:String,desc: String, phone: String, typeId: String?, startTime: TimeInterval, endTime: TimeInterval,brokerageCost: Double, coOrganizer: String, vipCouponCost: Double, lng: Double, lat: Double, joinNumber: Int, title: String, urlPath: String, id: String?, cost: Double, type: Int,hostUnit: String, detailAddress: String)
    /**
     * 获取我发布的活动
     * @param <#name#> <#desc#>
     *
     */
    case getMyActivities(page: Int, size: Int, userId: Int)
    
    /**
     * 获取我加入过的活动
     * @param <#name#> <#desc#>
     *
     */
    case getMyJoinedActivities(page: Int, size: Int)
    
    /**
     * 关闭活动报名
     * @param <#name#> <#desc#>
     *
     */
    case closeActivityApply
    
}

var kNetworkActivityID = "0"

extension ActivityNetwork : TargetType {
    
    
    public var baseURL: URL {
        return URL.init(string: kBase_URL)!
    }
    
    public var path: String {
        switch self {
        case .getGroupActivityList:
            return "/yhsclub/act/type"
        case .searchGroupActivityList:
            return "/yhsclub/act/search"
        case .getActivityDetail:
            return "/yhsclub/act/activityDetail/\(kNetworkActivityID)"
        case .recordActivityBrowse:
            return "/yhsclub/browseInfos/\(kNetworkActivityID)/2"
        case .getActivityJoinList:
            
            return "/yhsclub/act/signs/\(kNetworkActivityID)";
        case .createActitivity:
            return "/yhsclub/act/activity";
        case .getMyActivities:
            
            return "/yhsclub/act/activities";
        case .getMyJoinedActivities:
            return "/yhsclub/act/hasJoinList";

        case .closeActivityApply:
            return "/yhsclub/act/activities/\(kNetworkActivityID)";

        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .createActitivity:
            return .post
        default:
            return .get
        }
        
    }
    
    public var task: Task {
        switch self {
        case .getGroupActivityList(let type, let pageSize, let pageIndex):
            return .requestParameters(parameters: ["type":type,"size":pageSize,"page":pageIndex], encoding: URLEncoding.default)
        case .searchGroupActivityList(let key, let pageSize, let pageIndex):
            return .requestParameters(parameters: ["key":key,"size":pageSize,"page":pageIndex], encoding: URLEncoding.default)
        case .getActivityDetail:
            return .requestPlain
        case .recordActivityBrowse:
            return .requestPlain
        case .getActivityJoinList(let page, let size):
            return .requestParameters(parameters: ["size":size,"page":page], encoding: URLEncoding.default);
        case .createActitivity(let address, let desc, let phone, let typeId, let startTime, let endTime, let brokerageCost, let coOrganizer, let vipCouponCost, let lng, let lat, let joinNumber, let title, let urlPath, let id, let cost, let type, let hostUnit, let detailAddress):
            
            return .requestParameters(parameters: ["address": address, "desc": desc, "phone": phone, "typeId": typeId ?? "", "startTime": startTime, "endTime": endTime, "brokerageCost": brokerageCost, "coOrganizer": coOrganizer, "vipCouponCost": vipCouponCost, "lng": lng, "lat": lat, "joinNumber": joinNumber, "title": title, "urlPath": urlPath, "id": id ?? "", "cost": cost, "type": type, "hostUnit": hostUnit, "detailAddress": detailAddress], encoding: URLEncoding.default);

        case .getMyActivities(let page, let size, let userId):
            return .requestParameters(parameters: ["size":size,"page":page,"userId":userId], encoding: URLEncoding.default);

        case .getMyJoinedActivities(let page, let size):
            return .requestParameters(parameters: ["size":size,"page":page], encoding: URLEncoding.default);
        case .closeActivityApply:
            return .requestParameters(parameters: ["status":3], encoding: URLEncoding.default);

        }
    }
    
    public var headers: [String : String]? {
        return ["authorization":LoginManager.manager.token]
        
    }
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    
    
}
