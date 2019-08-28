//
//  IMGroupManager.swift
//  华商领袖
//
//  Created by hansen on 2019/5/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation


class IMGroupManager: NSObject {
    
    static let kGroupConfig = "kGroupConfig_key";
    private override init() {
        super.init()
    }
    /**
     * 0 : 未设置 1： 已设置
     * ["isSetDisturb":"0"]
     *
     */
    private var _groupConfig: [String: Int]?
    var groupConfig:[String : Int] {
        
        set {
            _groupConfig = newValue;
        }
        
        get {
            if _groupConfig != nil {
                return _groupConfig!;
            }
            if let dict = UserDefaults.standard.object(forKey: IMGroupManager.kGroupConfig) {
                return dict as! [String : Int];
            }
            var dict: [String : Int] = [:];
            dict["0"] = 0;
            UserDefaults.standard.set(dict, forKey: IMGroupManager.kGroupConfig);
            return dict;
        }
        
    }
    var cacheGroups:[String:TIMGroupInfo] = [:]
    static let shared = IMGroupManager()
    static func getGroupInfo(_ groupID: String, finished: @escaping ((TIMGroupInfo?) ->Void)) {
        if groupID.count == 0 {
            finished(nil);
            return
        }
        //先从缓存取
        if let result = IMGroupManager.shared.cacheGroups[groupID] {
            finished(result);
            return;
        }
        ///先从数据库查
        
        TIMGroupManager.sharedInstance()?.getGroupInfo([groupID], succ: { (response) in
            
            finished(response?.first as? TIMGroupInfo);
            IMGroupManager.shared.cacheGroups[groupID] = (response?.first as! TIMGroupInfo);
        }, fail: { (code, errmsg) in
            finished(nil);
            SVProgressHUD.showError(withStatus: errmsg);
        });
        
    }
    
    static func getGroupsInfo(_ groupsID: [String], finished: @escaping (([TIMGroupInfo]?) ->Void)) {
        if groupsID.count == 0 {
            finished(nil);
            return
        }
        TIMGroupManager.sharedInstance()?.getGroupInfo(groupsID, succ: { (response) in
            
            finished(response as? [TIMGroupInfo]);
            for item in response as! [TIMGroupInfo] {
                IMGroupManager.shared.cacheGroups[item.group] = item;
            }

        }, fail: { (code, errmsg) in
            
            finished(nil);
            SVProgressHUD.showError(withStatus: errmsg);
        })
    }
}
