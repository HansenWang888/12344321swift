//
//  CreateGroupVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/17.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class CreateGroupVC: BaseVC {

    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var groupTypeView: UIView!

    @IBOutlet weak var avatarBtn: UIButton!
    private var cityCode: String = "158"
    @IBOutlet weak var commitBtn: UIButton!
    private var location: String = ""
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var groupType: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建社群"
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(locationClick))
        self.locationView.addGestureRecognizer(tapGesture)
        let tapType = UITapGestureRecognizer.init(target: self, action: #selector(groupTypeSeletct))
        self.groupTypeView.addGestureRecognizer(tapType)
        self.avatarBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        self.avatarBtn.clipsToBounds = true
        self.avatarBtn.addRounded(radius: self.avatarBtn.width * 0.5)
        
        // Do any additional setup after loading the view.
    }
    @objc func groupTypeSeletct() {
        
        DYSiglePickerView.init("主办单位选择", dataSources: ["同乡社群","行业社群","兴趣社群"]).showOnView(nil) {[weak self] (items) in
            self?.typeLabel.text = items[1] as? String;
            self?.typeLabel.textColor = UIColor.black
            self?.groupType = (items[0] as! Int) + 1;
        }
        
    }
    @objc func locationClick() {
        
        let vc = LocationVC.init()
        vc.confirmLocationCallback = {
            [weak self] (areaCode: String, adsress: String,latitude: Double, longitude: Double) in
            //            self?.cityCode = areaCode
            self?.location = adsress
            self?.latitude = latitude
            self?.longitude = longitude
            self?.locationLabel.text = "已定位"
            self?.locationLabel.textColor = UIColor.black
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func avatarBtnClick(_ sender: Any) {
        let vc = TZImagePickerController.init()
        vc.maxImagesCount = 1
        vc.didFinishPickingPhotosHandle = {
            [weak self] (images, _, _) in
            //            self?.imageView.image = images?.first
            self?.avatarBtn.setBackgroundImage(images?.first, for: UIControl.State.normal)
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func commitBtnClick(_ sender: Any) {
        
        if self.avatarBtn.backgroundImage(for: UIControl.State.normal) == nil {
            SVProgressHUD.showInfo(withStatus: "请上传您的头像")
            return
        }
        
        if self.nameField.text!.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请填写社群名称")
            return
        }
        if self.groupType == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择社群类型")
            return
        }
        if self.cityCode.count == 0 {
            SVProgressHUD.showInfo(withStatus: "需要定位您的位置")
            return
        }
        if self.addressField.text!.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入详细地址")
            return
        }
        
        SVProgressHUD.show(withStatus: "正在提交...")
        
        NetWorkRequest(target: CommonNetwork.uploadFile(directPath: "organization", data: [self.avatarBtn.backgroundImage(for: UIControl.State.normal)!])) { (result) in

            switch result {

            case .successful(let response):

                let array = response as! [String]

                NetWorkRequest(target: HomeNetwork.oranizationPersonApply(address: self.location, areaCode: self.cityCode, businessLicense: "", categoryType: 1, detailAddress: self.addressField.text!, groupName: self.nameField.text!, groupUri: array.first!, latitude: self.latitude, longitude: self.longitude, type: self.groupType), finished: { (result) in

                    switch result {

                    case .successful:
                        SVProgressHUD.showSuccess(withStatus: "创建成功！")
                        //替换当前vc 跳转到社群详情页
                        let vc = GroupDetailVC.init()
                        self.navigationController?.viewControllers.removeLast()
                        self.navigationController?.viewControllers.append(vc)
                        self.navigationController?.setViewControllers((self.navigationController?.viewControllers)!, animated: true)
                        break

                    case .failure(let errmsg) :
                        SVProgressHUD.showError(withStatus: errmsg)
                        break
                    }
                })
                break

            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break

            }

        }
        
        
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
