//
//  MyPaymentVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit


class PayModel {
    
    var giftBagId: Int = 0
    var price: String = "0.0";
    var productId: String = "";
    var sid: Int = 0;
    var type: Int = 0;
    
}

class MyPaymentVC: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    
    
    var payFinished: (() -> Void)?
    
    var payModel: PayModel
    
    
    required init(_ payModel: PayModel) {
        self.payModel = payModel;
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付详情"

        self.payBtn.addRounded(radius: 5)
        self.wechatBtn.isSelected = true
        self.integralBtn.isEnabled = false
        self.alipayBtn.isEnabled = false
        self.priceLabel.text = "￥ \(self.payModel.price)"
        
        // Do any additional setup after loading the view.
    }

    
    
    
    

    @IBOutlet weak var integralBtn: UIButton!
    
    @IBOutlet weak var alipayBtn: UIButton!

    @IBOutlet weak var wechatBtn: UIButton!

    @IBAction func payTypeSelect(_ sender: Any) {
        
        
    }
    @IBAction func payBtnClick(_ sender: Any) {
        SVProgressHUD.show(withStatus: nil);
        NetWorkRequest(target: MyNetwork.wechatPay(giftBagId: self.payModel.giftBagId , price: self.payModel.price, productId: self.payModel.productId, sid: self.payModel.sid, type: self.payModel.type)) { (result) in
            
            switch result {
                
            case .successful(let response):
                SVProgressHUD.dismiss()
                let dict = response as! [String : Any]
                let model = MyPreparePayModel.init(JSON: dict)
                let payreq = PayReq.init()
                payreq.nonceStr = model!.noncestr!
                payreq.package = model!.package!
                payreq.partnerId = model!.partnerid!
                payreq.prepayId = model!.prepayid!
                payreq.sign = model!.sign!
                payreq.timeStamp = UInt32(model!.timestamp!)!
                WXApiManager.shared.payAlertController(self, request: payreq, paySuccess: { (returnKey) in
                    if self.payFinished != nil {
                        self.payFinished!();
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }) {
                    SVProgressHUD.showError(withStatus: "支付失败！")
                }
                
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
