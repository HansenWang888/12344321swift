//
//  RechargeVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/28.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class RechargeVC: BaseVC {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var integralView: UIView!
    @IBOutlet weak var alipayBtn: UIButton!
    @IBOutlet weak var wechatBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    
    var price: String = "10"
    
    var integral: Double?
    
    var currentSelectBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "积分充值"
        self.balanceLabel.text = "\(self.integral ?? 0)积分"
        self.payBtn.addTarget(self, action: #selector(payBtnClick), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.integralView.subviews.count == 0 {
            setupIntegralView()
        }
    }
    private func setupIntegralView() {
        let countArray: Array<String> = ["10","25","50","100","500","1000","5000","10000","-1"]
        
        for item in countArray {
            let btn = UIButton.init(type: UIButton.ButtonType.custom)
            btn.setTitle(item + "积分", for: UIControl.State.normal)
            btn.setTitleColor(kThemeTextColor, for: UIControl.State.normal)
            btn.setTitleColor(kThemeColor, for: UIControl.State.selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.addRounded(radius: 5)
            btn.addBorder(width: 1, borderColor: UIColor.gray)
            self.integralView.addSubview(btn)
            let index: Int = countArray.index(of: item)!
            let margin: CGFloat = 20.0
            let width = (self.integralView.width - margin * 4 ) / 3
            let height = (self.integralView.height - 40) / 3
            let origX = CGFloat(index % 3) * (margin + width) + margin
            let origY = CGFloat(index / 3) * (10 + height) + 10
            btn.frame = CGRect.init(x: origX, y: origY, width: width, height: height)
            if index == countArray.count - 1 {
                btn.setTitle(item, for: UIControl.State.normal)
            }
            btn.addTarget(self, action: #selector(priceBtnClick(sender:)), for: UIControl.Event.touchUpInside)
            if item == "-1" {
                btn.setTitle("其他数量", for: UIControl.State.normal)
                self.integralView.addSubview(self.customPriceView)
                self.customPriceView.frame = CGRect.init(x: btn.x + 10, y: btn.y + 10, width: btn.width - 20, height: btn.height - 20)
            }
            btn.tag = Int(item)!
            if index == 0 {
                btn.isSelected = true
                btn.addBorder(width: 1, borderColor: kThemeColor)
                self.currentSelectBtn = btn
            }
            
        }
    }
    
    @objc private func priceBtnClick(sender: UIButton) {
        
        self.currentSelectBtn?.addBorder(width: 1, borderColor: .gray)
        self.currentSelectBtn?.isSelected = false
        sender.addBorder(width: 1, borderColor: kThemeColor)
        sender.isSelected = true
        self.currentSelectBtn = sender
        if sender.tag == -1 {
            //其他数量
            self.customPriceView.isHidden = false
            self.customPriceView.becomeFirstResponder()
            self.price = self.customPriceView.text ?? "10"
        } else {
            self.customPriceView.isHidden = true
            self.customPriceView.endEditing(true)
            self.price = "\(sender.tag)"
        }
        
        
    }

    @IBAction func btnClick(_ sender: UIButton) {
        
        switch sender {
        case self.alipayBtn:
            
            break
        case self.wechatBtn:
            
           
            
            break
        case self.payBtn:
            
            break
        default:
            break
        }

    }
    
    
    @objc private func payBtnClick () {
        if self.currentSelectBtn?.tag == -1 {
            if self.customPriceView.text?.count == 0{
                SVProgressHUD.showInfo(withStatus: "请输入要充值的数量")
                return
            }
            self.price = self.customPriceView.text ?? "10"
        }
        SVProgressHUD.show(withStatus: nil)
        NetWorkRequest(target: MyNetwork.wechatPay(giftBagId: 0, price: self.price, productId: "", sid: 0, type: 6)) { (result) in
            SVProgressHUD.dismiss()
            switch result {
                
            case .successful(let response):
                let dict = response as! [String : Any]
                let payModel = MyPreparePayModel.init(JSON: dict)
                let payreq = PayReq.init()
                payreq.nonceStr = payModel!.noncestr!
                //iOS端特别配置 "Sign=WXpay"
                payreq.package = payModel!.package!
                payreq.partnerId = payModel!.partnerid!
                payreq.prepayId = payModel!.prepayid!
                payreq.sign = payModel!.sign!
                //Int64(payModel!.timestamp!)! / 1000
                payreq.timeStamp = UInt32(payModel!.timestamp!)!
                WXApiManager.shared.payAlertController(self, request: payreq, paySuccess: { (returnKey) in
                    debugPrint("支付成功")
                }, payFail: {
                    debugPrint("支付失败")
                })
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
    }
    
    private var customPriceView: UITextField = {
        
        let view = UITextField.init()
        view.keyboardType = UIKeyboardType.decimalPad
        let rightlabel = UILabel.init()
        rightlabel.textColor = kThemeColor
        rightlabel.text = "积分："
        rightlabel.sizeToFit()
        rightlabel.font = UIFont.systemFont(ofSize: 15)
        rightlabel.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        view.leftView = rightlabel
        view.isHidden = true
        view.backgroundColor = UIColor.white
        view.textColor = kThemeColor
        view.font = UIFont.systemFont(ofSize: 15)
        view.textAlignment = NSTextAlignment.center
        return view
        
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
