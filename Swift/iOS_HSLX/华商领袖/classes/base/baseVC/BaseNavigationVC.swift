//
//  BaseNavigationVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class BaseNavigationVC: UINavigationController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let navBar = UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationVC.self])
        navBar.tintColor = UIColor.HWColorWithHexString(hex: "#333333")
        let baritem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [BaseNavigationVC.self])
        
        baritem.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -1000, vertical: 0), for: UIBarMetrics.default)
        
        
    }
}
