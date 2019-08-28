//
//  NetworkManager.swift
//  华商领袖
//
//  Created by abc on 2019/4/1.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON


///// 定义基础域名
//let Moya_baseURL = "http://news-at.zhihu.com/api/"
//
///// 定义返回的JSON数据字段
//let RESULT_CODE = "flag"      //状态码
//
//let RESULT_MESSAGE = "message"  //错误消息提示
///// 超时时长
private var requestTimeOut:Double = 30
/////网络错误的回调
typealias errorCallback = (() -> (Void))
//
//
/////网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
//private let myEndpointClosure = { (target: API) -> Endpoint in
//    ///这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
//    let url = target.baseURL.absoluteString + target.path
//    var task = target.task
//    
//    /*
//     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
//     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
//     */
//    //    let additionalParameters = ["token":"888888"]
//    //    let defaultEncoding = URLEncoding.default
//    //    switch target.task {
//    //        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
//    //    case .requestPlain:
//    //        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
//    //    case .requestParameters(var parameters, let encoding):
//    //        additionalParameters.forEach { parameters[$0.key] = $0.value }
//    //        task = .requestParameters(parameters: parameters, encoding: encoding)
//    //    default:
//    //        break
//    //    }
//    /*
//     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
//     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
//     */
//
//
//    var endpoint = Endpoint(
//        url: url,
//        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
//        method: target.method,
//        task: task,
//        httpHeaderFields: target.headers
//    )
//    requestTimeOut = 30//每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
//    switch target {
//    case .easyRequset:
//        return endpoint
//    case .register:
//        requestTimeOut = 5
//        return endpoint
//
//    default:
//        return endpoint
//    }
//}
//
/////网络请求的设置
//private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
//    do {
//        var request = try endpoint.urlRequest()
//        //设置请求时长
//        request.timeoutInterval = requestTimeOut
//        // 打印请求参数
//        if let requestData = request.httpBody {
//            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
//        }else{
//            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
//        }
//        done(.success(request))
//    } catch {
//        done(.failure(MoyaError.underlying(error, nil)))
//    }
//}
//
///*   设置ssl
// let policies: [String: ServerTrustPolicy] = [
// "example.com": .pinPublicKeys(
// publicKeys: ServerTrustPolicy.publicKeysInBundle(),
// validateCertificateChain: true,
// validateHost: true
// )
// ]
// */
//
//// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
////private public func defaultAlamofireManager() -> Manager {
////
////    let configuration = URLSessionConfiguration.default
////
////    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
////
////    let policies: [String: ServerTrustPolicy] = [
////        "ap.grtstar.cn": .disableEvaluation
////    ]
////    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
////
////    manager.startRequestsImmediately = false
////
////    return manager
////}
//
//
///// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
/////但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了
//private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
//
//    print("networkPlugin \(changeType)")
//    //targetType 是当前请求的基本信息
//    switch(changeType){
//    case .began:
//        print("开始请求网络")
//
//    case .ended:
//        print("结束")
//    }
//}
//
//// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
////stubClosure   用来延时发送网络请求
//
//
//////网络请求发送的核心初始化方法，创建网络请求对象
//let Provider = MoyaProvider<API>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)
//
//
//
///// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个
/////
///// - Parameters:
/////   - target: 网络请求
/////   - completion: 请求成功的回调
//func NetWorkRequest(_ target: API, completion: @escaping successCallback ){
//    NetWorkRequest(target, completion: completion, failed: nil, errorResult: nil)
//}
//
//
///// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个
/////
///// - Parameters:
/////   - target: 网络请求
/////   - completion: 成功的回调
/////   - failed: 请求失败的回调
//func NetWorkRequest(_ target: API, completion: @escaping successCallback , failed:failedCallback?) {
//    NetWorkRequest(target, completion: completion, failed: failed, errorResult: nil)
//}
//
//
/////  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
/////
///// - Parameters:
/////   - target: 网络请求
/////   - completion: 成功
/////   - failed: 失败
/////   - error: 错误
//func NetWorkRequest(_ target: API, completion: @escaping successCallback , failed:failedCallback?, errorResult:errorCallback?) {
//    //先判断网络是否有链接 没有的话直接返回--代码略
//    if !isNetworkConnect{
//        print("提示用户网络似乎出现了问题")
//        return
//    }
//    //这里显示loading图
//    Provider.request(target) { (result) in
//        //隐藏hud
//        switch result {
//        case let .success(response):
//            do {
//                let jsonData = try JSON(data: response.data)
//                print(jsonData)
//                //               这里的completion和failed判断条件依据不同项目来做，为演示demo我把判断条件注释了，直接返回completion。
//
//                completion(String(data: response.data, encoding: String.Encoding.utf8)!)
//
//                print("flag不为1000 HUD显示后台返回message"+"\(jsonData[RESULT_MESSAGE].stringValue)")
//
//                //                if jsonData[RESULT_CODE].stringValue == "1000"{
//                //                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
//                //                }else{
//                //                if failed != nil{
//                //                    failed(String(data: response.data, encoding: String.Encoding.utf8)!)
//                //                }
//                //                }
//
//            } catch {
//            }
//        case let .failure(error):
//            guard let error = error as? CustomStringConvertible else {
//                //网络连接失败，提示用户
//                print("网络连接失败")
//                break
//            }
//            if errorResult != nil {
//                errorResult!()
//            }
//        }
//    }
//}


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}

///// Demo中并未使用，以后如果有数组转json可以用这个。
//struct JSONArrayEncoding: ParameterEncoding {
//    static let `default` = JSONArrayEncoding()
//
//    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
//        var request = try urlRequest.asURLRequest()
//
//        guard let json = parameters?["jsonArray"] else {
//            return request
//        }
//        
//        let data = try JSONSerialization.data(withJSONObject: json, options: [])
//
//        if request.value(forHTTPHeaderField: "Content-Type") == nil {
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        }
//
//        request.httpBody = data
//
//        return request
//    }
//}


let kBase_URL = "http://www.zqcw8888.com"


class NetworkManager {
    

    private init() {}
    
    static let manager = NetworkManager()
    public typealias Successful = (_ result: [String : Any]) -> Void
    public typealias Failure = (_ error: Error) -> Void
    
    func getVerifyCode(phoneNumber: String, success: @escaping Successful, failure: @escaping Failure) {
        
        let url = "http://www.zqcw8888.com/yhsclub/sms/loginMsg/\(phoneNumber)"
        Alamofire.request(url).responseJSON { (response) in
            response.result.ifSuccess {
                success(response.result.value as! [String : Any])
            }
            
            response.result.ifFailure {
                failure(response.result.value as! Error)
            }
        }
        
    }
    
    func getRequest(url:String,parameters:[String:Any], success: @escaping Successful, failure: @escaping Failure) {
        
        Alamofire.request(url).responseJSON { (response) in
            response.result.ifSuccess {
                success(response.result.value as! [String : Any])
            }
            
            response.result.ifFailure {
                failure(response.result.value as! Error)
            }
        }
    }
    //获取本机IP
    public var ipAddress: String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
    
   
    
}
enum NetworkCallBack<Value> {
    
    case successful(Value)
    
    case failure(String)
    
}

typealias Finished = ((NetworkCallBack<Any>)) -> Void

func NetWorkRequest<T: TargetType>(target: T, finished : @escaping Finished)  {
    //先判断网络是否有链接 没有的话直接返回--代码略
    if !isNetworkConnect{
        SVProgressHUD.showInfo(withStatus: "网络已断开连接")
        return
    }
    let provider = MoyaProvider<T>()
    //这里显示loading图
    provider.request(target) { (result) in
        //隐藏hud
        switch result {
        case let .success(response):
            
            if response.statusCode == 200 {
                do {
                    let dict = try response.mapJSON() as! [String :Any]
                    
                    var code = dict["code"] as? Int
                    if code == nil {
                        code = dict["errcode"] as? Int
                    }
                    var errmsg = dict["msg"] as? String
                    if errmsg == nil {
                        errmsg = dict["errmsg"] as? String
                    }
                    if code == 200 {
                        let resultData = dict["result"]
                        finished(.successful(resultData as Any))
                    } else {
                        if errmsg == nil {
                            finished(.successful(dict as Any))
                        } else {
                            finished(.failure(errmsg ?? "未知错误") )
                        }
                    }
                } catch {
                    finished(.failure("数据解析失败") )
                }
            } else {
                finished(.failure("请求代码错误 \(response.statusCode)"))
            }
            break
        case let .failure(error):
            debugPrint(error)
            finished(.failure("加载失败！"))
            break
            
        }
    }
}
/**
 * 处理网络请求并且返回相应模型
 * @param R R具体的请求
 * @param listKey 返回数组数据对应的key
 * @param finished 回调
 */
func NetWorkRequestModel<R: TargetType,M : BaseModel>(network: R,listKey: String?,modelType: M.Type,finished: @escaping ([M]?) -> Void) {
    
    
    
    NetWorkRequest(target: network) { (result) in
        switch result {
        case .successful(let response):
            var array: [[String : Any]]? = nil
            if (listKey?.count ?? 0) > 0 {
                //使用这个key取相对应的数据
                guard let resultArray = (response as! [String : Any])[listKey!] as? [[String : Any]] else {
                    return
                }
                array = resultArray
            } else {
                guard let resultArray = response as? [[String : Any]] else {
                    return
                }
                array = resultArray
            }
            var models:[M] = []
            for item in array! {
                models.append(M.init(JSON: item)!)
            }
            finished(models)
            break
            
        case .failure(let errmsg) :
            finished(nil)
            SVProgressHUD.showError(withStatus: errmsg)
            break
        }
        
    }
}
