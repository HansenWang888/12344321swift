//
//  IMUserManager.swift
//  华商领袖
//
//  Created by hansen on 2019/5/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation


class IMUserManager: NSObject{
    
    private override init() {
        super.init()
    }
    static let shared = IMUserManager()
    
    
    
    
    
    static func getUserInfo(_ userID: String, finished: @escaping ((TIMUserProfile?) ->Void)) {
        if userID.length == 0 {
            finished(nil);
            return
        }
        ///先从数据库查
        
        TIMFriendshipManager.sharedInstance()?.getUsersProfile([userID], forceUpdate: true, succ: { (profiles) in
            finished(profiles?.first);
        }, fail: { (code, errmsg) in
            finished(nil);
            SVProgressHUD.showError(withStatus: errmsg);
        });
        
    }
    static func getUsersInfo(_ usersID: [String], finished: @escaping (([TIMUserProfile]?) -> Void)) {
        if usersID.count == 0 {
            finished(nil);
            return
        }
        ///先从数据库查
        
        TIMFriendshipManager.sharedInstance()?.getUsersProfile(usersID, forceUpdate: true, succ: { (users) in
            finished(users ?? []);
        }, fail: { (code, errmsg) in
            finished(nil);
            SVProgressHUD.showError(withStatus: errmsg);
        });
        
    }
}
