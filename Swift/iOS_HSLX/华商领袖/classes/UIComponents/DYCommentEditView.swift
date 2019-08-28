//
//  DYCommentEditView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYCommentEditView: UIView, UITextFieldDelegate{

    
    var placeHolder = "请输入要评论内容" {
        
        didSet {
            self.textField.placeholder = self.placeHolder;
        }
    };
    var btnTitle = "确定" {
        
        didSet {
            
            self.sendBtn.setTitle(self.btnTitle, for: UIControl.State.normal);
        }
    };
    var btnColor = kThemeColor {
        
        didSet {
            self.sendBtn.setTitleColor(self.btnColor, for: UIControl.State.normal);
        }
        
    };
    var finishedEditCallback:((_ content: String) -> Void)?
    required init() {
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight));
        self.backgroundColor = UIColor.clear;
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name:UIResponder.keyboardWillHideNotification, object: nil);
        self.addSubview(self.contentView);
        self.contentView.addSubview(self.textField);
        self.contentView.addSubview(self.sendBtn);
        
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.height.equalTo(50);
        }
        self.sendBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.right.equalToSuperview();
            make.width.equalTo(50);
        }
        self.textField.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(5);
            make.bottom.equalToSuperview().offset(-5);
            make.right.equalTo(self.sendBtn.snp.left).offset(-8);
        }
        
        self.sendBtn.addTarget(self, action: #selector(sendBtnClick), for: UIControl.Event.touchUpInside)
        self.textField.delegate = self;
        self.onClick(self, #selector(dismiss));
        self.contentView.addBorder(width: 0.5);
    }
    class func show(onView: UIView?, finished: @escaping (String) ->Void) {
        
        let view = DYCommentEditView.init();
        view.textField.becomeFirstResponder();
        view.finishedEditCallback = finished;
        if let contentView = onView {
            contentView.addSubview(view);
            view.frame = contentView.bounds;
        } else {
            UIApplication.shared.keyWindow?.addSubview(view);
        }
    }
    
    func show(onView: UIView?, finished: @escaping (String) ->Void) {
        
        self.textField.becomeFirstResponder();
        self.finishedEditCallback = finished;
        if let contentView = onView {
            contentView.addSubview(self);
            self.frame = contentView.bounds;
        } else {
            UIApplication.shared.keyWindow?.addSubview(self);
        }
    }
    
    
    @objc private func dismiss() {
        self.textField.endEditing(true);
    }
    
    @objc private func sendBtnClick() {
        
        if self.finishedEditCallback != nil {
            self.finishedEditCallback!(self.textField.text!);
        }
        
    }
    
    @objc private func keyboardWillShow(_ info: Notification) {
        
        let userInfo = info.userInfo;
        
        let rect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue;
        
        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double;
        
        UIView.animate(withDuration: duration) {
        
            self.contentView.transform = CGAffineTransform.init(translationX: 0, y: -rect.height);
        }
        
    
    }
    
    @objc private func keyboardWillHide(_ info: Notification) {
        let userInfo = info.userInfo;
        
        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double;
        
        UIView.animate(withDuration: duration, animations: {
            self.contentView.transform = CGAffineTransform.identity;

        });
        self.finishedEditCallback = nil;
        self.isHidden = true;
        self.removeFromSuperview();
    }
    
    private lazy var contentView: UIView = {
        let view = UIView();
        view.backgroundColor = UIColor.white;
        return view;
    }()

    private lazy var textField: UITextField = {
        let field = UITextField();
        field.placeholder = self.placeHolder;
        field.borderStyle = UITextField.BorderStyle.roundedRect;
        return field;
    }()
    
    private lazy var sendBtn: UIButton = {
        
        let btn = UIButton.init(type: UIButton.ButtonType.system);
        btn.setTitle(self.btnTitle, for: UIControl.State.normal);
        btn.setTitleColor(self.btnColor, for: UIControl.State.normal);
        btn.isEnabled = false;
        
        return btn;
    }()


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.sendBtn.isEnabled = string.count > 0 ? true : false;
        return true;
    }
    
    deinit {
        self.finishedEditCallback = nil;
        NotificationCenter.default.removeObserver(self);
    }

}
