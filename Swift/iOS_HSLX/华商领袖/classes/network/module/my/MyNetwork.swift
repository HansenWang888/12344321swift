//
//  MyNetwork.swift
//  华商领袖
//
//  Created by hansen on 2019/4/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation
import Moya


public enum MyNetwork {
    
    //获取vip申请信息
    case getVIPApplyInfo
    
    //微信支付
    case wechatPay(giftBagId: Int, price: String, productId: String, sid: Int, type: Int)
    
    /**
     * 获取我的钱包信息
     *
     */
    case getMyWalletInfo
    
    /**
     * 获取我的银行卡
     *
     *
     */
    case getMyBankCards
    
    /**
     * 提现
     * @param amount 金额
     * @param banNo 卡号
     * @param banCode 参照安卓传1001
     * @param realName 真实姓名
     */
    case withdrawToBank(amount: Double, banNo: String, bankCode: Int, realName: String)
    
    /**
     * 获取我的余额明细
     * @param type 1: 余额明细  0： 积分明细
     */
    case getMyBalanceOrIntegralDetail(page: Int, size: Int)
    
    /**
     * 获取某个人的个人信息
     * @param kTargetUserID
     *
     */
    case getSomeoneUserInfo
    
    /**
     * 获取个人信息中的营业范围
     * @param kTargetUserID
     *
     */
    case getUserUnits
    
    /**
     * 获取个人信息中的个人动态
     * @param kTargetUserID
     *
     */
    case getUserDynamics(page: Int, size: Int)
    
    /**
     * 获取我的好友动态
     * @param <#name#> <#desc#>
     *
     */
    case getMyFriendDynamics(page: Int, size: Int);
    
    
    
}
///1: 余额明细  0： 积分明细
var kNetworkDetailType = 0

extension MyNetwork : TargetType {
    
    public var baseURL: URL {
        return URL.init(string: kBase_URL)!
    }
    
    public var path: String {
        switch self {
        case .getVIPApplyInfo:
            return "/yhsclub/vip/all"
        case .wechatPay:
            return "/yhsclub/wechat/pay/preOrder"
        case .getMyWalletInfo:
            return "/yhsclub/integral"
        case .getMyBankCards:
            return "yhsclub/bank/my"
        case .withdrawToBank:
            return "/yhsclub/wechat/withdrawToBank"
        case .getMyBalanceOrIntegralDetail:
            return "/yhsclub/integral/\(kNetworkDetailType)/2"
        case .getSomeoneUserInfo:
            return "/yhsclub/user/\(kTargetUserID)"

        case .getUserUnits:
            return "/yhsclub/user/units/\(kTargetUserID)"
        case .getUserDynamics:
            return "/yhsclub/user/personageDynamic/\(kTargetUserID)"
            
        case .getMyFriendDynamics:
            return "/yhsclub/user/dynamics/friend";
            
        

        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .wechatPay:
            return .post
        default :
            return .get
        }
        
        
    }
    
    public var task: Task {
        switch self {
        case .getVIPApplyInfo:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        
        case .wechatPay(let giftBagId, let price, let productId, let sid, let type):
            return .requestParameters(parameters: ["giftBagId":giftBagId,"price":price,"productId":productId,"sid":sid,"type":type], encoding: JSONEncoding.default)
        case .getMyWalletInfo:
            return .requestPlain
        case .getMyBankCards:
            return .requestPlain
        case .withdrawToBank(let amount, let banNo, let bankCode, let realName):
            return .requestParameters(parameters: ["amount":amount,"banNo":banNo,"bankCode":bankCode,"realName":realName], encoding: URLEncoding.default)
        case .getMyBalanceOrIntegralDetail(let page, let size):
            return .requestParameters(parameters: ["page":page,"size":size], encoding: URLEncoding.default)
        case .getSomeoneUserInfo:
            return .requestPlain
        case .getUserUnits:
            return .requestPlain
        case .getUserDynamics(let page, let size):
            return .requestParameters(parameters: ["page":page,"size":size], encoding: URLEncoding.default)
        case .getMyFriendDynamics(let page, let size):
            return .requestParameters(parameters: ["size":size,"page":page], encoding: URLEncoding.default);
        }
    }
    
    public var headers: [String : String]? {
        
        switch self {
        case .wechatPay:
            return ["authorization":LoginManager.manager.token,"X-Forwarded-For": NetworkManager.manager.ipAddress]
        default:
            return ["authorization":LoginManager.manager.token]

        }
        
    }
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

}
