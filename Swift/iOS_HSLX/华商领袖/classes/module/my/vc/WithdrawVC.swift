//
//  WithdrawVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/28.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class WithdrawVC: BaseVC {

    @IBOutlet weak var subBankInfo: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var withdrawBtn: UIButton!
    
    @IBOutlet weak var withDrawAllBtn: UIButton!
    @IBOutlet weak var banNameLabel: UILabel!
    private var currentModel: MyBankCardModel?
    var balance: Double = 0.0
    var cards: [MyBankCardModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现"
        self.textfield.keyboardType = UIKeyboardType.decimalPad
        self.subBankInfo.isHidden = true
        self.banNameLabel.isHidden = true
        self.balanceLabel.text = "零钱余额 ￥ \(self.balance)"
        self.withdrawBtn.addRounded(radius: 3)
        self.textfield.rx.text.orEmpty.subscribe { (text) in
            let str = text.element
            if str?.count == 0 {
                self.withdrawBtn.isEnabled = false
                self.withdrawBtn.backgroundColor = UIColor.gray
            } else {
                self.withdrawBtn.isEnabled = true
                self.withdrawBtn.backgroundColor = kThemeColor
            }
            
        }.disposed(by: disposeBag)
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.loadData()
        // Do any additional setup after loading the view.
    }
    private func updateBanInfo(model: MyBankCardModel) {
        self.currentModel = model
        self.subBankInfo.isHidden = false
        self.banNameLabel.isHidden = false
        self.defaultLabel.isHidden = true
        self.banNameLabel.text = self.cards.first?.bank
        let bankNum = self.cards.first?.bankNo
        self.subBankInfo.text = "到账银行卡\((bankNum?.substring(fromIndex: bankNum!.length - 4)) ?? "0")银行尾号\(model.cardType ?? "借记卡")"
        
    }
    
    private func loadData() {
        SVProgressHUD.show(withStatus: nil)
        NetWorkRequest(target: MyNetwork.getMyBankCards) { (result) in
            
            SVProgressHUD.dismiss()
            switch result {
                
            case .successful(let response):
                let array = response as! [[String : Any]]
                for item in array {
                    self.cards.append(MyBankCardModel.init(JSON: item)!)
                }
                if self.cards.count > 0 {
                    self.updateBanInfo(model: self.cards.first!)
                }
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
    }

    @IBAction func cardSelectClick(_ sender: Any) {
        let vc = CardSelectVC()
        vc.selectedBankCardCallback = {
            [weak self] (model) in
            self?.updateBanInfo(model: model)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func withdrawAllClick(_ sender: Any) {
        let resultBalance = (self.balance - 1) * 0.001
        if resultBalance > 0 {
            self.textfield.text = "\(resultBalance)"
        }
    }
    @IBAction func withdrawBtnClick(_ sender: Any) {
        let resultBalance = (self.balance - 1) * 0.001

        if Double(self.textfield.text!)! > resultBalance {
            SVProgressHUD.showInfo(withStatus: "输入金额超过零钱余额")
            return
        }
        if self.currentModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择要提现的银行卡")
            return
        }
        
        SVProgressHUD.show(withStatus: nil)
        NetWorkRequest(target: MyNetwork.withdrawToBank(amount: Double(self.textfield.text!)!, banNo: self.currentModel?.bankNo ?? "", bankCode: 1001, realName: self.currentModel?.name ?? "")) { (result) in
            SVProgressHUD.dismiss()
            
            switch result {
                
            case .successful(_):
                
                UIAlertController.initAlertPromtVC(message: "恭喜您！提现成功，钱将在1-3个工作到达您的账户，请耐心等候...", confirmTitle: "知道了", confirmBlock: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
            
        }
        
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
