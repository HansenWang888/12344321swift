//
//  AuthenticateVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/27.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import RxSwift
class AuthenticateVC: BaseVC {

    
    var finishedCallback: (() -> Void)?
    
    private var cardNumber: String {
        return (self.tableView.visibleCells[2] as! AuthenticateCell).textField.text ?? ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实名认证"
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
        let name = cells.first?.textField.text
        let identifyNumber = cells[1].textField.text
        let cardNumber = cells[2].textField.text
        let bank = cells[3].textField.text
        let phone = cells.last?.textField.text
        
        if name?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "姓名不能为空")
            return
        }
        if identifyNumber?.IsIdentityCard() == false {
            SVProgressHUD.showInfo(withStatus: "无法识别该身份证号码，请重新输入！")
            return
        }
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
        NetWorkRequest(target: CommonNetwork.bankAuthorise(accountNo: cardNumber!, IdCard: identifyNumber!, mobile: phone!, name: name!)) { (result) in
            
            switch result {
                
            case .successful:
                SVProgressHUD.showSuccess(withStatus: "认证成功！")
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
            
            ["title":"真实姓名","placeHolder":"请输入","keybord":"0"],
            ["title":"身份证号","placeHolder":"请输入","keybord":"8"],
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


extension AuthenticateVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuthenticateCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.leftTitle.text = self.dataSources[indexPath.item]["title"]
        cell.textField.placeholder = self.dataSources[indexPath.item]["placeHolder"]
        if indexPath.item == 3 {
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
        if indexPath.row == 3 {
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.endEditing(true)
    }
}

class AuthenticateCell : UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubview() {
        
        self.contentView.addSubview(self.textField)
        self.contentView.addSubview(self.leftTitle)
        self.leftTitle.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(120)
        }
        self.textField.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
            make.left.greaterThanOrEqualTo(self.leftTitle.snp.right)
        }
        self.contentView.bringSubviewToFront(self.leftTitle)
    }
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.borderStyle = UITextField.BorderStyle.none
        return field
    }()
    
    lazy var leftTitle: UILabel = {
        let label = UILabel()
        label.textColor = kThemeTextColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
}
