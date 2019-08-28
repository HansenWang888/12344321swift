//
//  CreateActivytyVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/26.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit


class CreateActivytyVC: BaseVC {
    
    
    
    var activityID = "";
    var createFinishedCallback:(() -> Void)?

    private var model: ActivityGroupListModel?
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bottomViewConstrain: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    private var upEditView: ActivityEditUpView?
    @IBOutlet weak var commitBtn: UIButton!
    private var bottomEditView: ActivityEditDownView?
    
    private var latitude: Double?
    private var longtitude: Double?
    private var brokerageCost: Double = 0;
    private var vipCouponCost: Double = 0;
    private var isUploadImg: Bool = false;
    
    class func activityVCModify(_ model: ActivityGroupListModel) -> CreateActivytyVC {
        
        let vc = CreateActivytyVC.init();
        vc.commitBtn.setTitle("确认修改", for: UIControl.State.normal);
        vc.model = model;
        return vc;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建活动"
        
        // Do any additional setup after loading the view.
        self.setupSubviews();
        self.distributionSubview();
        
    }
    private func setupSubviews() {
        self.upEditView = ActivityEditUpView.initEditView();
        self.bottomEditView = ActivityEditDownView.initEditView();
        self.contentView.addSubview(self.upEditView!);
        self.contentView.addSubview(self.bottomEditView!);
        
        if self.model != nil {
            self.bgImageView.kf.setImage(with: URL.init(string: self.model?.urlPath ?? ""));
            self.upEditView?.titleTextfield.text = self.model?.activityTitle;
            self.upEditView?.startTimeField.text = Date.getFormdateYMDHM(timeStamp: self.model?.startTime ?? 0);
            self.upEditView?.endTimeField.text = Date.getFormdateYMDHM(timeStamp: self.model?.endTime ?? 0);
            self.upEditView?.priceField.text = "\(self.model?.cost ?? 0.0)";
            self.upEditView?.positionField.text = "已定位";
            self.upEditView?.locationField.text = self.model?.detailAddress;
            self.upEditView?.richTextLabel.text = self.model?.description;
            self.bottomEditView?.joinField.text = "\(self.model?.joinNumber ?? 0)";
            self.bottomEditView?.hostUnitField.text = self.model?.hostUnit;
            self.bottomEditView?.subUnitField.text = self.model?.coOrganizer;
            self.bottomEditView?.phoneField.text = self.model?.phone;
            self.latitude = self.model?.lat;
            self.longtitude = self.model?.lng;
            self.brokerageCost = self.model?.brokerageCost ?? 0;
            self.vipCouponCost = self.model?.vipCouponCost ?? 0;
            self.isUploadImg = true;
            self.upEditView?.address = self.model?.address;
            
        }

    }
    private func distributionSubview() {
        self.upEditView!.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(148)
        }
        self.bottomEditView!.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.upEditView!)
            make.top.equalTo(self.upEditView!.snp.bottom).offset(8)
            make.height.equalTo(240)
        }
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize.init(width: self.view.width, height: self.bottomEditView!.frame.maxY + 120);
        self.heightContraint.constant = self.scrollView.contentSize.height - self.scrollView.height;
        
    }
    
    
    
    
    
    @IBAction func addBtnClick(_ sender: Any) {
        
        let vc = TZImagePickerController.init(maxImagesCount: 1, delegate: self);
        
        self.present(vc!, animated: true, completion: nil);
        
        
    }
    @IBAction func reviewBtnClick(_ sender: UIButton) {
        
        
    }
    @IBAction func releaseBtnClick(_ sender: Any) {
        
        if !self.isUploadImg {
            SVProgressHUD.showInfo(withStatus: "宣传图不能空");
            return
        }
        if (self.upEditView!.titleTextfield.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "标题不能为空");
            return
        }
        if (self.upEditView!.startTimeField.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "开始时间不能为空");
            return
        }
        if (self.upEditView!.endTimeField.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "结束时间不能为空");
            return
        }
        if (self.upEditView!.priceField.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "价格不能为空");
            return
        }
        if (self.upEditView!.positionField.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "请设置您的定位");
            return
        }
        if (self.upEditView!.richTextLabel.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "位置不能为空");
            return
        }
        if (self.bottomEditView!.joinField.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "请填写参加人数");
            return
        }
        if (self.bottomEditView!.hostUnitField.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "请填写主办单位");
            return
        }
        if (self.bottomEditView!.subUnitField.text!.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "请填写协办单位");
            return
        }
        if self.bottomEditView!.phoneField.text!.isTellephoneNumber() == false {
            SVProgressHUD.showInfo(withStatus: "请填写正确的手机号码");
            return
        }
        let startTime = Date.dateFormatterStrToTimeStamp(self.upEditView!.startTimeField.text!);
        let endTime = Date.dateFormatterStrToTimeStamp(self.upEditView!.endTimeField.text!);
        if startTime == endTime {
            SVProgressHUD.showInfo(withStatus: "活动报名时间设置太短了啦");
            return
        }
        if startTime > endTime {
            SVProgressHUD.showInfo(withStatus: "开始时间不能大于结束时间");
            return
        }
        SVProgressHUD.show(withStatus: nil)
        if self.model != nil {
            NetWorkRequest(target: ActivityNetwork.createActitivity(address: self.upEditView!.address!, desc: self.upEditView!.richTextLabel.text!, phone: self.bottomEditView!.phoneField.text!, typeId: "", startTime: startTime, endTime: endTime, brokerageCost: self.brokerageCost, coOrganizer: self.bottomEditView!.hostUnitField.text!, vipCouponCost: Double(self.vipCouponCost), lng: self.model?.lng ?? 0, lat: self.model?.lat ?? 0, joinNumber: Int(self.bottomEditView!.joinField.text!)!, title: self.upEditView!.titleTextfield.text!, urlPath: self.model?.urlPath ?? "", id: self.model?.id , cost: Double(self.upEditView!.priceField.text!)!, type: 0, hostUnit: self.bottomEditView!.hostUnitField.text!, detailAddress: self.upEditView!.locationField.text!), finished: { (result) in
                
                switch result {
                case .successful:
                    SVProgressHUD.showSuccess(withStatus: "发布活动成功！");
                    if self.createFinishedCallback != nil{
                        self.createFinishedCallback!();
                    }
                    break
                    
                case .failure(let errmsg) :
                    SVProgressHUD.showError(withStatus: errmsg)
                    break
                    
                }
            })
            
        } else {
            NetWorkRequest(target: CommonNetwork.uploadFile(directPath: (self.upEditView?.titleTextfield.text!)!, data: [self.bgImageView.image!])) { (result) in
                
                switch result {
                case .successful(let response):
                    let pictures = response as! [String]
                    
                    NetWorkRequest(target: ActivityNetwork.createActitivity(address: self.upEditView!.address!, desc: self.upEditView!.richTextLabel.text!, phone: self.bottomEditView!.phoneField.text!, typeId: "", startTime: startTime, endTime: endTime, brokerageCost: self.brokerageCost, coOrganizer: self.bottomEditView!.hostUnitField.text!, vipCouponCost: Double(self.vipCouponCost), lng: self.upEditView!.longtitude!, lat: self.upEditView!.latitude!, joinNumber: Int(self.bottomEditView!.joinField.text!)!, title: self.upEditView!.titleTextfield.text!, urlPath: pictures.first!, id: self.activityID , cost: Double(self.upEditView!.priceField.text!)!, type: 0, hostUnit: self.bottomEditView!.hostUnitField.text!, detailAddress: self.upEditView!.locationField.text!), finished: { (result) in
                        
                        switch result {
                        case .successful(let response):
                            let dict = response as! [String : Any]
                            SVProgressHUD.showSuccess(withStatus: "发布活动成功！");
                            if self.createFinishedCallback != nil{
                                self.createFinishedCallback!();
                            }
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
extension CreateActivytyVC: TZImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        self.bgImageView.image = photos.first;
        self.isUploadImg = true;
    }
    
    
}


class ActivityEditUpView: UIView {
   
    
    
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var richTextLabel: UILabel!
    
    var latitude: Double?
    var longtitude: Double?
    var address: String?
    class func initEditView() -> ActivityEditUpView {
        let view = Bundle.main.loadNibNamed("CreateActivityEditView", owner: nil, options: nil)!.first! as! ActivityEditUpView;
        view.richTextLabel.onClick(view, #selector(richTextEdit));
        view.addRounded(radius: 5);
        return view;
        
    }
   
    
    @objc private func richTextEdit() {
        
        let vc = DYRichTextVC.init()
        if self.richTextLabel.text != "请描述相关内容..." {
            vc.content = self.richTextLabel.text;
        }
        vc.editFinished = {
            [weak self] (content) in
            if content.count == 0 {
                self?.richTextLabel.text = "请描述相关内容...";
            }
            self?.richTextLabel.text = content;
        }
        self.viewContainingController()!.navigationController?.pushViewController(vc, animated: true);
        
    }
    @IBAction func startTimeClick(_ sender: Any) {
        DYTimePickerView.init("开始时间").showOnView(nil) { [weak self] (date) in
            
            let dateStr = date.first as! String;
            let end = Date.dateFormatterStrToTimeStamp(self?.endTimeField.text ?? "0")
            
            let start = Date.dateFormatterStrToTimeStamp(dateStr);
            self?.startTimeField.text = dateStr;

            if end < start && end != 0 {
                SVProgressHUD.showInfo(withStatus: "开始时间不能大于结束时间")
                self?.startTimeField.text = "";

            }
            
        }
        
        
    }
    @IBAction func endTimeClick(_ sender: Any) {
        
        DYTimePickerView.init("结束时间").showOnView(nil) { [weak self] (date) in
            let dateStr = date.first as! String;

            let start = Date.dateFormatterStrToTimeStamp(self?.startTimeField.text ?? "0")
            
            let end = Date.dateFormatterStrToTimeStamp(dateStr);
            self?.endTimeField.text = dateStr;
            if end < start{
                SVProgressHUD.showInfo(withStatus: "结束时间不能小于开始时间")
                self?.endTimeField.text = "";
            }

            
        }
        
    }
    @IBAction func priceClick(_ sender: Any) {
        
    }
    @IBAction func positionClick(_ sender: Any) {
        let vc = LocationVC.init();
        vc.confirmLocationCallback = {
            [weak self] (areaCode, address, lat, lng) in
            self?.latitude = lat;
            self?.longtitude = lng;
            self?.address = address;
            self?.positionField.text = "已定位";
        }
        self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true);
    }
    
}

class ActivityEditDownView: UIView {
    
    @IBOutlet weak var joinField: UITextField!
    @IBOutlet weak var hostUnitField: UITextField!
    @IBOutlet weak var subUnitField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    class func initEditView() -> ActivityEditDownView {
        
        let view = Bundle.main.loadNibNamed("CreateActivityEditView", owner: nil, options: nil)!.last!  as! ActivityEditDownView
        view.addRounded(radius: 5);
        return view;
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
