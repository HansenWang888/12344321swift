//
//  DataTypeControlView.swift
//  华商领袖
//
//  Created by abc on 2019/3/25.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DataTypeControlView: UIView {
    
    //MARK: 公开
    var btnClickBlock: ((Int) -> Void)? = nil
    
    class func initControlView(sources: Array<String>) -> DataTypeControlView {
        let view = DataTypeControlView()
        view.sources = sources
        view.setupSubview()
        return view
    }
    
    
    
    
    
    
    //MARK: 私有
    private var sources: Array<String> = []
    private let stackView = UIStackView()
    private weak var lastSelectedBtn: UIButton? = nil
    private func setupSubview() {
        self.backgroundColor = UIColor.white
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        stackView.distribution = UIStackView.Distribution.fillEqually
        for index in 0...self.sources.count - 1 {
            
            let btn = UIButton()
            btn.setTitle(self.sources[index], for: UIControl.State.normal)
            btn.setTitleColor(kThemeTextColor, for: UIControl.State.normal)
            btn.setTitleColor(kThemeColor, for: UIControl.State.selected)
            btn.tag = index
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            stackView.addArrangedSubview(btn)
            btn.addTarget(self, action: #selector(btnClik(_:)), for: UIControl.Event.touchUpInside)
            if index == 0 {
                btn.isSelected = true
                self.lastSelectedBtn = btn
            }
        }
        
        self.addSubview(self.ledgementView)
        self.ledgementView.snp.makeConstraints { (make) in
            make.width.equalTo(35)
            make.height.equalTo(2)
            make.centerX.equalTo(stackView.arrangedSubviews.first!)
            make.bottom.equalToSuperview()
        }
        
    }
    @objc private func btnClik(_ sender: UIButton) {
        self.lastSelectedBtn?.isSelected = false
        UIView.animate(withDuration: 0.25) {
            self.ledgementView.snp.remakeConstraints({ (make) in
                make.width.equalTo(35)
                make.height.equalTo(2)
                make.centerX.equalTo(sender)
                make.bottom.equalToSuperview()
            })
            sender.isSelected = true
            self.layoutIfNeeded()
        }
        self.lastSelectedBtn = sender
        
        if self.btnClickBlock != nil {
           btnClickBlock!(sender.tag)
        }
    }
    private lazy var ledgementView: UIView = {
        
        let view = UIView()
        view.backgroundColor = kThemeColor
        return view
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
