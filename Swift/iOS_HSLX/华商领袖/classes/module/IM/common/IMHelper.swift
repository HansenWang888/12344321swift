//
//  IMHelper.swift
//  华商领袖
//
//  Created by hansen on 2019/5/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation


/**
 * 获取腾讯云组件的文件路径
 * @param name 文件名
 *
 */
func kTUIKitResourcePath(_ name: String) -> String? {
    return Bundle.main.path(forResource: "TUIKitResource", ofType: "bundle")?.appending("/\(name)") ?? "";
}

let kDefaultAvatarPath: String = kTUIKitResourcePath("default_head") ?? ""

