//
//  DYCustomePromtView.swift
//  华商领袖
//
//  Created by hansen on 2019/4/11.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYApplyPromtView: UIView , UITextViewDelegate{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var cancleBt: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var confirmBtnClickBlock: (() -> Void)? = nil
    
    class func initPromptView() -> DYApplyPromtView {
        
        let view =  Bundle.main.loadNibNamed("DYApplyPromtView", owner: self, options: nil)?.first as! DYApplyPromtView
        
        return view
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.cancleBt.addTarget(self, action: #selector(cancleBtnClick), for: UIControl.Event.touchUpInside)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: UIControl.Event.touchUpInside)
        self.textView.delegate = self
    }
    
    class func show () -> DYApplyPromtView {
        
        let view = DYApplyPromtView.initPromptView()
        kKeyWindow?.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }
    func dismiss() {
        self.removeFromSuperview()
        self.confirmBtnClickBlock = nil
    }
    @objc func cancleBtnClick() {
        self.dismiss()
        
    }
    @objc func confirmBtnClick() {
        
        if self.confirmBtnClickBlock != nil {
            self.confirmBtnClickBlock!()
        }
        self.dismiss()
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    deinit {
        debugPrint("------8888888888888----------\(self.classForCoder)")
    }
}

