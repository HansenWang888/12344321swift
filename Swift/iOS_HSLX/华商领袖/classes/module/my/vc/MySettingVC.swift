//
//  MySettingVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/23.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MySettingVC: BaseVC {
    
    private var tableView: UITableView?
    private var dataSources: NSArray?
    let dBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统设置"
        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        let exitBtn = UIButton()
        exitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        exitBtn.setTitle("退出登录", for: UIControl.State.normal)
        exitBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        exitBtn.rx.tap.subscribe {_ in
            let vc = UIAlertController.init(title: "温馨提示", message: "是否确定退出登录?", preferredStyle: UIAlertController.Style.alert)
            let cancle = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
            let confirm = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default, handler: { (cfm) in
                LoginManager.manager.isLogin = false
                NotificationCenter.default.post(name: NSNotification.Name.nLogin_exit, object: nil)
            })
            confirm.setValue(UIColor.red, forKey: "titleTextColor")
            vc.addAction(cancle)
            vc.addAction(confirm)
            self.present(vc, animated: true, completion: nil)
            
        }.disposed(by: dBag)
        self.tableView?.tableFooterView = exitBtn
        self.tableView?.tableFooterView?.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 44)
        self.tableView?.tableFooterView?.backgroundColor = UIColor.white
    
        self.dataSources = NSArray.init(contentsOfFile: Bundle.main.path(forResource: "MySetting.plist", ofType: nil)!)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.reloadData()
        // Do any additional setup after loading the view.
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

extension MySettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataSources?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSources?[section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
           cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        }
        let array = self.dataSources![indexPath.section] as! NSArray
        let dict = array[indexPath.row] as! NSDictionary
        cell!.textLabel?.text = dict["title"] as? String
        cell!.detailTextLabel?.text = dict["rightTitle"] as? String
        cell!.textLabel?.textColor = UIColor.HWColorWithHexString(hex: "#11304C")
        if Bool(truncating: dict["hasNext"] as! NSNumber) {
            
            cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        } else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
        }
        if indexPath.section == 2 {
            cell!.textLabel?.textAlignment = NSTextAlignment.center
        }
    
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}
