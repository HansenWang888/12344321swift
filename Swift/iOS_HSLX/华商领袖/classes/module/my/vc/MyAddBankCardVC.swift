//
//  MyAddBankCardVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/27.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit


/**
 * 添加银行卡
 * @param <#name#> <#desc#>
 *
 */
class MyAddBankCardVC: BaseVC {

    var finishedCallback: (() -> Void)?
    
    private var cardNumber: String {
        return (self.tableView.visibleCells[0] as! AuthenticateCell).textField.text ?? ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增银行"
        self.view.addSubview(self.tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: UIControl.Event.touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    @objc func confirmBtnClick() {
        
        let cells = self.tableView.visibleCells as! [AuthenticateCell]
        let cardNumber = cells[0].textField.text
        let bank = cells[1].textField.text
        let phone = cells.last?.textField.text
        if cardNumber?.IsBankCard() == false {
            SVProgressHUD.showInfo(withStatus: "无法识别该卡号，请重新输入！")
            return
        }
        if bank?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择银行")
            return
        }
        if phone?.isTellephoneNumber() == false {
            SVProgressHUD.showInfo(withStatus: "无法识别该手机号，请重新输入！")
            return
        }
        SVProgressHUD.showInfo(withStatus: "正在提交...")
        NetWorkRequest(target: CommonNetwork.bankAuthorise(accountNo: cardNumber!, IdCard: LoginManager.manager.user?.idCard ?? "", mobile: phone!, name: LoginManager.manager.user?.realName ?? "")) { (result) in
            
            switch result {
                
            case .successful:
                SVProgressHUD.showSuccess(withStatus: "添加成功！")
                if self.finishedCallback != nil {
                    self.finishedCallback!()
                }
                self.navigationController?.popViewController(animated: true)
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
            
        }
        
    }
    
    lazy var tableView: UITableView = {
        
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.register(AuthenticateCell.classForCoder(), forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        
        btn.setTitle("确定", for: UIControl.State.normal)
        btn.addRounded(radius: 5)
        btn.backgroundColor = kThemeColor
        return btn
        
    }()
    
    lazy var dataSources: Array<Dictionary<String, String>> = {
        
        return [
            
            ["title":"储蓄账号","placeHolder":"请输入","keybord":"8"],
            ["title":"发卡行","placeHolder":"请选择","keybord":"0"],
            ["title":"预留手机号","placeHolder":"请输入","keybord":"8"],
            
            ]
    }()
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension MyAddBankCardVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuthenticateCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.leftTitle.text = self.dataSources[indexPath.item]["title"]
        cell.textField.placeholder = self.dataSources[indexPath.item]["placeHolder"]
        if indexPath.item == 1 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.textField.isEnabled = false
            cell.textField.snp.updateConstraints { (make) in
                make.right.equalToSuperview()
            }
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
            cell.textField.isEnabled = true
        }
        cell.textField.keyboardType = UIKeyboardType(rawValue: Int(self.dataSources[indexPath.item]["keybord"]!)!)!
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if self.cardNumber.length > 0 {
                if self.cardNumber.IsBankCard() == false {
                    SVProgressHUD.showInfo(withStatus: "无法识别该卡号，请重新输入！")
                    return
                }
                let cell = tableView.cellForRow(at: indexPath) as! AuthenticateCell
                let number = self.cardNumber[0..<6]
                cell.textField.text = String.recognizeBankNameBy(number)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.endEditing(true)
    }
}


