//
//  BaseTabBarVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class BaseTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for dict in vcConfig {
            //动态获取命名空间(CFBundleExecutable这个键对应的值就是项目名称,也就是命名空间)
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            
            //将字符串转化为类
            //默认情况下,命名空间就是项目名称,但是命名空间是可以修改的
            let cls:AnyClass? = NSClassFromString(namespace + "." + dict["class"]!)
            
            //通过类创建对象
            //将anyClass转换为指定的类型
            let viewControllerCls = cls as! UIViewController.Type
            
            //通过class创建对象
            let vc = viewControllerCls.init()
            let navVC = BaseNavigationVC.init(rootViewController: vc)
            vc.title = dict["title"]
            vc.tabBarItem.image = UIImage(named: dict["title"]!)
            
            self.addChild(navVC)
        }
        
    }
    
    
    lazy var vcConfig : [Dictionary] = {
        
        return [
            [
                "class" : "HomeVC",
                "title" : "主页",
                "icon" : ""
            ],
            [
                "class" : "ActivityVC",
                "title" : "活动",
                "icon" : ""
            ],
//            [
//                "class" : "OpportunityVC",
//                "title" : "商机",
//                "icon" : ""
//            ],
            [
                "class" : "IMVC",
                "title" : "消息",
                "icon" : ""
            ],
            [
                "class" : "MyVC",
                "title" : "我的",
                "icon" : ""
            ]
        ]
        
    }()
}
