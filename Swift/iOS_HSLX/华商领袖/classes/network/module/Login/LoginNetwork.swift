//
//  LoginNetwork.swift
//  华商领袖
//
//  Created by abc on 2019/4/1.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

let loginProvider = MoyaProvider<LoginNetwork>()

public enum LoginNetwork{
    
    case login(phone : String,code: String)
    
    case getUserInfo
    
    case getWXAccessToken(appid: String, secret: String, code: String)
    
    case wxUserInfo(token: String, openID: String)
    //type == 4  参照安卓
    case wxLogin(unionid: String,sex: Int, token: String, username: String,userIcon: String,openId: String)
    
    
}


extension LoginNetwork: TargetType {

    public var baseURL: URL {
        
        switch self {
        case .getWXAccessToken :
            return URL(string:"https://api.weixin.qq.com")!
        case .wxUserInfo:
            return URL(string:"https://api.weixin.qq.com")!
        default:
            return URL(string: kBase_URL)!
        }
        
        
    }
    public var path: String {
        switch self {
        case .login:
            return "/yhsclub/user/v1.0.2/loginCode"
            
        case .getUserInfo:
            return "/yhsclub/user/\(LoginManager.manager.user?.userId ?? 0)"
            
        case .getWXAccessToken :
            return "/sns/oauth2/access_token"
        case .wxUserInfo:
            return "/sns/userinfo"
        case .wxLogin:
            return "/yhsclub/user/v1.0.2/loginWithOther"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .wxLogin:
            return .post
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
            
        case .login(let phone,let code):
            
            var parameters: [String : Any] = [:]
            parameters["phone"] = phone
            parameters["code"] = code
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .getUserInfo:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getWXAccessToken(let appid, let secret, let code):
            let parameters: [String : Any] = ["grant_type":"authorization_code","appid":appid,"secret":secret,"code":code]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .wxUserInfo(let token, let openID):
            let parameters: [String : Any] = ["access_token":token,"openid":openID]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .wxLogin(let unionid, let sex, let token, let username,let userIcon, let openId):
            let parameters: [String : Any] = ["unionid":unionid,"sex":sex,"type":4, "token":token,"userName":username,"userIcon":userIcon,"openId":openId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        }
    }
    public var headers: [String : String]? {
        
        switch self {
        case .getUserInfo:
            return ["authorization":LoginManager.manager.token]
        default:
            return nil
        }
        
    }
    
}
