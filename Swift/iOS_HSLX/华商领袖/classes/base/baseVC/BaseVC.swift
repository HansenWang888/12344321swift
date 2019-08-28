//
//  BaseVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    func showAuthrizeVC(_ finished: (() -> Void)?) {
        let alert = UIAlertController.initAlertCustomVC(message: "您还没完成实名认证", confirmTitle: "去认证") { (_) in
            let vc  = AuthenticateVC.init()
            vc.finishedCallback = {
                if finished != nil {
                    finished!()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        debugPrint("---------88*888888888----------\(self.classForCoder)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
