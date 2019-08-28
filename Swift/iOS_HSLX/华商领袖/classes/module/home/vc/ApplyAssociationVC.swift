//
//  ApplyAssociationVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/17.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class ApplyAssociationVC: BaseVC {

    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!

    private var cityCode: String = "158"
    private var location: String = ""
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商协会入驻"
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(locationClick))
        self.locationView.addGestureRecognizer(tapGesture)
        self.avatarBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        self.avatarBtn.clipsToBounds = true
        self.avatarBtn.addRounded(radius: self.avatarBtn.width * 0.5)
        // Do any additional setup after loading the view.
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
            SVProgressHUD.showInfo(withStatus: "请填写分部名称")
            return
        }
        
        if self.imageBtn.image(for: UIControl.State.normal) == nil {
            SVProgressHUD.showInfo(withStatus: "请上传您的营业执照或个人身份素材")
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
        NetWorkRequest(target: CommonNetwork.uploadFile(directPath: "organization", data: [self.avatarBtn.backgroundImage(for: UIControl.State.normal)!, self.imageBtn.image(for: UIControl.State.normal)!])) { (result) in
            
            switch result {
                
            case .successful(let response):
                
                let array = response as! [String]
                
                NetWorkRequest(target: HomeNetwork.oranizationPersonApply(address: self.location, areaCode: self.cityCode, businessLicense: array.last!, categoryType: 2, detailAddress: self.addressField.text!, groupName: self.nameField.text!, groupUri: array.first!, latitude: self.latitude, longitude: self.longitude, type: 0), finished: { (result) in
                    
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
    
    @IBAction func ientifyBtnClick(_ sender: Any) {
        let vc = TZImagePickerController.init()
        vc.maxImagesCount = 1
        vc.didFinishPickingPhotosHandle = {
            [weak self] (images, _, _) in
            self?.imageBtn.setImage(images?.first, for: UIControl.State.normal)
            self?.imageBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
            self?.imageBtn.imageView!.clipsToBounds = true
        }
        self.present(vc, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
