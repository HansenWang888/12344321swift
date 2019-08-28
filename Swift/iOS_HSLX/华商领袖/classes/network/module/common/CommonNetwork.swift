//
//  CommonNetwork.swift
//  华商领袖
//
//  Created by hansen on 2019/4/10.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation
import Moya


public enum CommonNetwork {
    
    case uploadFile(directPath: String, data: [UIImage])
    
    case bankAuthorise(accountNo: String, IdCard: String, mobile: String, name: String)
    
    
}

extension CommonNetwork : TargetType {
   
    
    public var baseURL: URL {
        return URL.init(string: kBase_URL)!
    }
    
    public var path: String {
        switch self {
        case .uploadFile:
            return "/yhsclub/file/upload"
        case .bankAuthorise:
            return "/yhsclub/bank/auth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .uploadFile:
            return .post
        case .bankAuthorise:
            return .post
        }
        
    }
        
    public var task: Task {
        switch self {
        case .uploadFile(let path,let data):
            var formDataAry: [MultipartFormData] = []
            for (_,image) in data.enumerated() {
                let data:Data = image.jpegData(compressionQuality: 0.8)!
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                dateStr = dateStr.appendingFormat("-%i.jpg", arc4random() % 1000000)
                let formData = MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: "image/jpeg")
                formDataAry.append(formData)
            }
            
            return .uploadCompositeMultipart(formDataAry, urlParameters: ["dirPath": path])
        case .bankAuthorise(let accountNo, let IdCard, let mobile, let name):
            
            return .requestParameters(parameters: ["accountNo":accountNo,"IdCard":IdCard,"mobile":mobile,"name":name], encoding: JSONEncoding.default)
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
