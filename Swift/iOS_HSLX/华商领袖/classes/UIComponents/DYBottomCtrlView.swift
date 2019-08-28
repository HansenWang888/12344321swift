//
//  DYBottomCtrlView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/7.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

/**
 * 带白色间隔线的一组button
 *
 */
class DYBottomCtrlView: UIView {

    var font: UIFont = UIFont.systemFont(ofSize: 14)
    var textColor = UIColor.white
    var images: [String]?
    var titles: [String]? {
        //第一次赋值不会被调用
        didSet {
            
            self.setupSubview();
            
        }
        
    }
    var btnClickBlock: ((_ index: Int) -> Void)?
    private var stackView: UIStackView = UIStackView.init();
    required init(titles: [String]) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 44))
        self.backgroundColor = kThemeColor
        self.titles = titles;
        self.setupSubview();
        
    }
    private func setupSubview() {
        self.stackView.removeFromSuperview();
        self.stackView = UIStackView.init();
        self.stackView.axis = NSLayoutConstraint.Axis.horizontal
        self.stackView.distribution = UIStackView.Distribution.fillEqually
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        for item in self.titles! {
            let btn = WNButton.init()
            btn.setTitle(item, for: UIControl.State.normal)
            btn.setTitleColor(self.textColor, for: UIControl.State.normal)
            btn.titleLabel?.font = self.font
            btn.tag = titles!.index(of: item)!
            btn.addTarget(self, action: #selector(btnClick(_:)), for: UIControl.Event.touchUpInside)
            if images != nil {
                btn.setImage(UIImage.init(named: images![btn.tag]), for: UIControl.State.normal)
            }
            
            self.stackView.addArrangedSubview(btn)
            if btn.tag != titles!.count - 1 {
                
                let view = UIView.init()
                view.backgroundColor = UIColor.white
                self.addSubview(view)
                view.snp.makeConstraints { (make) in
                    make.centerY.right.equalTo(btn)
                    make.width.equalTo(1)
                    make.height.equalTo(35)
                }
                
            }
        }
    }
    
    func addTarget(_ target: AnyObject, selector: Selector) {
     
        
    }
    func updateTitles(_ titles: [String]) {
        self.titles = titles;
        
    }
    
    func updateTitle(index: Int, title: String) {
        
        let btn = self.stackView.arrangedSubviews[tag] as? UIButton
        btn?.setTitle(title, for: UIControl.State.normal)
        
    }
    
    
    @objc private func btnClick(_ sender:UIButton) {
        
        if (self.btnClickBlock != nil) {
            self.btnClickBlock!(sender.tag)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
