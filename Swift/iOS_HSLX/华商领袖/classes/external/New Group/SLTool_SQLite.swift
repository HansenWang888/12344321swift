//
//  SLTool_SQLite.swift
//  shanlinOA
//
//  Created by labi3285 on 2017/11/29.
//  Copyright © 2017年 shanlin. All rights reserved.
//

import Foundation
import SQLite3

/*
 声明：
 1、这是本项目对SQLite c数据库的简单封装，以适应swift语法
 2、由于SQLite底层采用文本格式储存数据，出于各方面的考虑，采用本工具的数据库存取，全部采用文本格式的 key/value
 3、每个数据库db，要对应一个本工具实体，不可混搭,建议只采用一个db
 */

class SLTool_SQLite {
    
    required init() {
        
    }
    
    struct Result: CustomStringConvertible {
        let success: Bool
        let code: Int32
        
        init(code: Int32) {
            self.code = code
            self.success = code == SQLITE_OK
        }
        var description: String {
            return "(\(code))"
        }
    }
    
    private var db: OpaquePointer? = nil
    
    /// 打开db
    func openDB(path: String) -> Result {
        
        let code = sqlite3_open(path, &db)
        return Result(code: code)
    }
    
    /// 执行语句
    func execute(SQL: String) -> Result {
        let cSQL = SQL.cString(using: .utf8)
        let errMsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        let code = sqlite3_exec(db, cSQL, nil, nil, errMsg)
        return Result(code: code)
    }
    
    /// 查询数据库
    func queryDB(SQL : String) -> [[String : String?]]? {
        
        var stmt: OpaquePointer? = nil
        
        if SQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            if let cSQL = (SQL.cString(using: .utf8)) {
                if sqlite3_prepare_v2(db, cSQL, -1, &stmt, nil) == SQLITE_OK {
                    var mArr = [[String : String?]]()
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        var dic = [String : String?]()
                        for i in 0..<sqlite3_column_count(stmt) {
                            
                            /// 键值默认为空字符串
                            var key: String = ""
                            if let cKey = sqlite3_column_name(stmt, i) {
                                if let _key = String(validatingUTF8: cKey) {
                                    key = _key
                                }
                            }
                            
                            /// 值可以为空
                            var value: String? = nil
                            if let cValue = sqlite3_column_text(stmt, i) {
                                value = String(cString:cValue)
                            }
                            dic[key] = value
                        }
                        mArr.append(dic)
                    }
                    return mArr
                }
            }
        }
        return nil
    }
    
}
