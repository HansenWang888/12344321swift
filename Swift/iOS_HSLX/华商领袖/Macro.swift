//
//  Macro.swift
//  华商领袖
//
//  Created by abc on 2019/3/25.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


//当前系统版本
let kSystemVersion = (UIDevice.current.systemVersion as NSString).floatValue
//屏幕宽度
let kScreenWidth = UIScreen.main.bounds.width
//屏幕高度
let kScreenHeight = UIScreen.main.bounds.height
//是否是iphoneX
let kiPhoneX = (kScreenWidth == 375.0 && kScreenHeight == 812.0)
//状态栏高度
let kStatusBarH = UIApplication.shared.statusBarFrame.size.height
//导航栏高度
let kNavBarH = kStatusBarH + 44.0
//标签栏高度
let kTabBarH = UIApplication.shared.statusBarFrame.size.height > 20 ? 83 : 49;
//获取keyWindow
let kKeyWindow = UIApplication.shared.keyWindow


let kThemeColor = UIColor.HWColorWithHexString(hex: "#3e6bff")
let kThemeTextColor = UIColor.HWColorWithHexString(hex: "#333333")
let kPlaceholderImage = UIImage.init(named: "placeholder")
let kDefaultAvatarImage = UIImage.init(named: "defaultAvatar")
let disposeBag = DisposeBag()
