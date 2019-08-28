//
//  DYPickerView.swift
//  华商领袖
//
//  Created by hansen on 2019/4/18.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYPickerView: UIView {

    
    var compeletedBlock: ((_ items:[Any]) ->Void)?
    
    var title: String? {
        
        didSet {
            
            self.titleLabel.text = self.title;
        }
    }
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.setupSubview()
    }
    
    func setPicker(_ picker: UIView) {
        self.pickerContentView.addSubview(picker);
        picker.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
   
    /**
     * 显示到某个view
     * @param view 要显示的view 为nil时显示到window
     *
     */
    func showOnView(_ view: UIView?, compeleted: @escaping ([Any]) -> Void) {
        self.compeletedBlock = compeleted
        if view != nil {
            view?.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            return
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    @objc func dismiss() {
        self.removeFromSuperview()
        self.compeletedBlock = nil
    }
    
    
    private func setupSubview() {
        self.addSubview(self.contentView);
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.cancleBtn)
        self.contentView.addSubview(self.confirmBtn)
        self.contentView.addSubview(self.pickerContentView)
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(244)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(44)
            make.left.equalTo(self.cancleBtn.snp.right)
            make.right.equalTo(self.confirmBtn.snp.left)
        }
        self.cancleBtn.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(self.titleLabel)
        }
        self.confirmBtn.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(self.titleLabel)
        }
        self.pickerContentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom)
        }
        
        self.cancleBtn.addTarget(self, action: #selector(cancleBtnClick), for: UIControl.Event.touchUpInside)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: UIControl.Event.touchUpInside)
        
        self.backgroundColor = UIColor.HWColorWithHexString(hex: "#000000", alpha: 0.4)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func cancleBtnClick() {
        self.dismiss()
        
    }
    @objc func confirmBtnClick() {
        
        
        self.dismiss()
    }
    private lazy var pickerContentView: UIView = {
        let view = UIView();
        
        return view;
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    
    private lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.system)
        btn.setTitle("取消", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.system)
        btn.setTitle("确定", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        return btn
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.HWColorWithHexString(hex: "#333333")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    

}


