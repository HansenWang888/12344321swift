//
//  MyWallet.swift
//  华商领袖
//
//  Created by abc on 2019/3/27.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class MyWallet: BaseVC {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var integralLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的钱包"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "明细记录", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBtnClick))
        self.automaticallyAdjustsScrollViewInsets = true
//        self.navigationItem.rightBarButtonItem?.tintColor = .white
//        self.navigationItem.backBarButtonItem?.tintColor = .white
//        self.navigationItem.leftBarButtonItem?.tintColor = .white

        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage.from(color: kThemeColor), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage.from(color: .clear)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = nil
//        self.navigationController?.navigationBar.barStyle = .default
//        self.navigationController?.navigationBar.isTranslucent = false


    }
    
    private func loadData() {
        SVProgressHUD.show(withStatus: nil)
        NetWorkRequest(target: MyNetwork.getMyWalletInfo) { (result) in
            SVProgressHUD.dismiss()
            switch result {
            case .successful(let response):
                let dict = response as! [String : Any]
                let balance = dict["balance"] as! [String : Any]
                let integral = dict["integral"] as! [String : Any]
                self.integralLabel.text = "\(integral["total"] ?? 0)"
                self.balanceLabel.text = "\(balance["total"] ?? 0)"
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
        
    }
    
    
    @IBAction func rechargeBtnClick(_ sender: Any) {
        let vc = RechargeVC()
        vc.integral = Double(self.integralLabel.text!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func withdrawBtnClick(_ sender: Any) {
        let vc = WithdrawVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cardBtnClick(_ sender: Any) {
        let vc = CardManagerVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func rightBtnClick () {
        let vc = MyWalletDetailVC.init()
       
        self.navigationController?.pushViewController(vc, animated: true)
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
