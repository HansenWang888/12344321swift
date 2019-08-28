//
//  IMNetwork.swift
//  华商领袖
//
//  Created by hansen on 2019/4/29.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Moya


public enum IMNetwork {
    
    
    /**
     * 注册
     * @param headUrl 头像路径
     *
     */
    case registerIM(headUrl: String, nickName: String, userId: Int)
    /**
     * 获取腾讯云的私钥，在登录后调用
     *
     */
    case getIMUserSign
    
    /**
     * 获取好友列表
     *
     */
    case getFriends(page: Int, size: Int, fromUserId: Int)
    /**
     * 获取我关注的人的列表
     *
     */
    case getAttentions(page: Int, size: Int, fromUserId: Int)
    /**
     * 获取粉丝列表
     *
     */
    case getFollows(page: Int, size: Int, toUserId: Int)

    
    /**
     * 获取社群列表
     * @param category 1： 社群 2： 商协会 3： 俱乐部
     *
     */
    case getGroupList(categoryType: Int)
    
    /**
     * 关注
     * kTargetUserID 用户的userid
     */
    case attentionUser
    
    /**
     * 取消关注
     * kTargetUserID 用户的userid
     */
    case cancleAttentionUser
    
    /**
     * 获取我的评论跟点赞
     *
     */
    case getCommentsAndLikes(page: Int, size: Int)
    
}
var kTargetUserID = 0

extension IMNetwork : TargetType {
    
    
    public var baseURL: URL {
        return URL.init(string: kBase_URL)!
    }
    
    public var path: String {
        switch self {
        case .getIMUserSign:
            return "/yhsclub/im/userSig"
        
        case .registerIM:
            return "/yhsclub/im/accountImport"
        case .getFriends:
            return "/yhsclub/user/friends"

        case .getAttentions:
            return "/yhsclub/user/attentions"

        case .getFollows:
            return "/yhsclub/user/follows"

        case .getGroupList:
            return "/yhsclub/im/groupInfos/in"
        case .attentionUser:
            
            return "/yhsclub/user/attention/\(kTargetUserID)"
        case .cancleAttentionUser:
            return "/yhsclub/user/cancelAttention/\(kTargetUserID)"
        case .getCommentsAndLikes:
            return "/yhsclub/user/commentLikes/";
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .attentionUser:
            
            return .post
        case .cancleAttentionUser:
            return .post
        default :
            return .get
        }
        
    }
    
    public var task: Task {
        switch self {
            
        case .getIMUserSign:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .registerIM(let headUrl, let nickName, let userId):
            return .requestParameters(parameters: ["headUrl":headUrl,"nickName":nickName,"userId":userId], encoding: URLEncoding.default)
        case .getFriends(let page, let size, let fromUserId):
            return .requestParameters(parameters: ["page":page,"size":size,"fromUserId":fromUserId], encoding: URLEncoding.default)
        case .getAttentions(let page, let size, let fromUserId):
            return .requestParameters(parameters: ["page":page,"size":size,"fromUserId":fromUserId], encoding: URLEncoding.default)

        case .getFollows(let page, let size, let toUserId):
            return .requestParameters(parameters: ["page":page,"size":size,"toUserId":toUserId], encoding: URLEncoding.default)

        case .getGroupList(let categoryType):
            
            return .requestParameters(parameters: ["categoryType":categoryType], encoding: URLEncoding.default)
        case .attentionUser:
            
            return .requestPlain
        case .cancleAttentionUser:
            
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        case .getCommentsAndLikes(let page, let size):
            
            return .requestParameters(parameters: ["page":page,"size":size], encoding: URLEncoding.default)
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
