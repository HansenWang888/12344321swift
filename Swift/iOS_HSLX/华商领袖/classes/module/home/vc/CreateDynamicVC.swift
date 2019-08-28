//
//  ActivityCreateDynamicVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/26.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import JXPhotoBrowser
class CreateDynamicVC: BaseVC {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewConstrainHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomViewConstrain: NSLayoutConstraint!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    private var pictrues: [String] = []
    @IBOutlet weak var locationBtn: UIButton!
    private var images: [UIImage] = []
    private var location: String?
    private var latitude: Double = LocationManager.shared.latitude ?? 0
    private var longitude: Double = LocationManager.shared.longitude ?? 0
    var groupid: String?;
    var finishedCallback: (() -> Void)?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubView()
        // Do any additional setup after loading the view.
    }
    
    private func setupSubView() {
        self.title = "动态发布"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancleBtnClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: UIBarButtonItem.Style.plain, target: self, action: #selector(commitBtnClick))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.textView.delegate = self
        self.view.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.textView).offset(8)
        }
        self.textView.rx.text.orEmpty.changed.subscribe(onNext: {[weak self] (text) in
            self?.placeholderLabel.isHidden = text.count > 0 ? true : false
            self?.limitLabel.text = "\(text.count)/150"
            self?.navigationItem.rightBarButtonItem?.isEnabled = (text.count == 0 || text.count > 150) ? false : true
            self?.limitLabel.textColor = text.count > 150 ? UIColor.red : kThemeTextColor
            }, onError: { (error) in
                debugPrint(error)
        }, onCompleted: {
        }) {
            }.disposed(by: disposeBag)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        
    }
    
    @objc func keyboardWillShow(_ info: Notification) {
        let userInfo = info.userInfo
        
        let rect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            if self.bottomView.frame.maxY != UIScreen.main.bounds.height {
                //iphoneX
                self.bottomConstrain.constant = -rect.height + 34

            } else {
                
                self.bottomConstrain.constant = -rect.height
            }
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func keyboardWillDismiss(_ info: Notification) {
        self.bottomConstrain.constant = 0

    }

    @objc private func cancleBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func commitBtnClick() {
        
        if self.images.count > 0 {
            //上传图片
            SVProgressHUD.show(withStatus: "正在上传图片...")
            NetWorkRequest(target: CommonNetwork.uploadFile(directPath:"person_dynamic", data: self.images)) { (result) in
                switch result {
                case .successful(let response):
                    self.pictrues = response as! [String]
                    self.submit()
                    break
                case .failure(let errmsg):
                    SVProgressHUD.showError(withStatus: errmsg)
                    break
                }
            }
        } else {
            self.submit()
        }
        
    }
    
    private func submit() {
        SVProgressHUD.show(withStatus: "正在发布...")
        NetWorkRequest(target: HomeNetwork.createPersonageDynamic(title: "", picture: self.pictrueStr, location: self.location, longtitude: LocationManager.shared.longitude, latitude: LocationManager.shared.latitude, id: 0, eventTime: 0, typeId: self.groupid, content: self.textView.text, type: 0)) { (result) in
            
            switch result {
                
            case .successful:
                if self.finishedCallback != nil {
                    self.finishedCallback!();
                }
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
    }
    
    private var pictrueStr: String {
        var pictruesStr = ""
        for item in self.pictrues {
            pictruesStr.append(item)
            if item != self.pictrues.last {
                pictruesStr.append(",")
            }
        }
        return pictruesStr
        
    }

    @IBAction func GPSBtnClick(_ sender: Any) {
        let vc = LocationVC.init()
        vc.confirmLocationCallback = {
            [weak self] (areaCode,address,latitude,longitude) in
            self?.location = address
            self?.latitude = latitude
            self?.longitude = longitude
            self?.locationBtn.setTitle(address, for: UIControl.State.normal)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "分享您身边的商业见闻..."
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.endEditing(true)
    }
}

extension CreateDynamicVC: UITextViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.textView.endEditing(true)
    }
}


extension CreateDynamicVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.gray
        if self.images.count != 9 && indexPath.item == self.images.count {
            if cell.contentView.subviews.count == 0 {
                let imageV = UIImageView.init()
                imageV.image = UIImage.init(named: "加号")
                imageV.contentMode = .center
                imageV.clipsToBounds = true
                cell.contentView.addSubview(imageV)
                imageV.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            return cell
        }
        if indexPath.item == 9 {
            cell.contentView.subviews.last?.removeFromSuperview()
            cell.isHidden = true
            return cell
        }
        
        if cell.contentView.subviews.count == 0 {
            
            let imageV = UIImageView.init()
            imageV.image = self.images[indexPath.item]
            cell.contentView.addSubview(imageV)
            imageV.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        } else {
            let imageV = cell.contentView.subviews.first as! UIImageView
            imageV.image = self.images[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.images.count != 9 && indexPath.item == self.images.count {
            //添加照片
            let pickerVC = TZImagePickerController.init()
            pickerVC.maxImagesCount = 9 - self.images.count
            pickerVC.pickerDelegate = self
            self.present(pickerVC, animated: true, completion: nil)
            
        } else {
            // 数据源
            let dataSource = JXLocalDataSource(numberOfItems: {
                // 共有多少项
                return self.images.count
            }, localImage: { index -> UIImage? in
                // 每一项的图片对象
                return self.images[indexPath.item]
            })
    
            // 打开浏览器
            JXPhotoBrowser(dataSource: dataSource).show(pageIndex: indexPath.item)
        
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let wh = (collectionView.size.width - 12) / 3
        
        return CGSize.init(width: wh, height: wh)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


extension CreateDynamicVC: TZImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        var indexes:[IndexPath] = []
        let count = photos.count
        for index in 0...count - 1 {
            self.images.insert(photos[index], at: 0)
            indexes.append(IndexPath.init(item: index , section: 0))
        }
        self.collectionView.insertItems(at: indexes)
        if self.images.count == 9 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.collectionView.reloadItems(at: [IndexPath.init(item: 9, section: 0)])
            }
            
        }
        
    }

}
