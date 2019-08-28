//
//  DYProgressHUD.swift
//  华商领袖
//
//  Created by abc on 2019/4/2.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYProgressHUD {
    
    private init(){}
    
    static let shared = DYProgressHUD()

    func showSuccess(message: String) {
        dismiss()
        showMessage(message)
        
    }
    func showError(errorMessage: String) {
        dismiss()
        showMessage(errorMessage)
    }
    func showLoadView(message: String?) {
        self.dismiss()
        let view = setupViewToWindow()
        view.titleLabel.text = message
        
    }
    
    func showLoadView(message: String?, onView: UIView) {
        self.dismiss()
        self.onView = onView
        let view = DYprogressView()
        self.onView?.addSubview(view)
        view.titleLabel.text = message
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func showMessage(_ message: String) {
        self.dismiss()
        let window = UIApplication.shared.keyWindow
        
        let view = DYprogressView()
        window?.addSubview(view)
        view.titleLabel.text = message
        view.updateTitleToCenter()
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 1.0
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1.5), execute: {
                UIView.animate(withDuration: 0.25, animations: {
                    view.alpha = 0
                }, completion: { (_) in
                    view.removeFromSuperview()
                })
            })
           
        }
    }
    
    func dismiss() {
        
        
        if let view = findPRogressView() {
            view.clear()
            UIView.animate(withDuration: 0.25) {
                view.removeFromSuperview()
            }
        }
       
    }
    
    private func setupViewToWindow () -> DYprogressView {
        let window = UIApplication.shared.keyWindow
        
        let view = DYprogressView()
        view.activityView.startAnimating()
        window?.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }
    
    private func findPRogressView() -> DYprogressView?{
        
        var resultView: DYprogressView?
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.classForCoder == DYprogressView.classForCoder() {
                resultView = (view as! DYprogressView)
            }
        })
        return resultView
    }
    
   
    private weak var onView: UIView?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
private class DYprogressView: UIView {
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupSubview()
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        
    }
    
    func clear() {
        self.activityView.stopAnimating()
        self.pictureView.image = nil
        self.titleLabel.text = nil
        
    }
    
    private func setupSubview() {
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.size.equalTo(120)
            make.center.equalToSuperview()
        }
        self.contentView.addSubview(self.activityView)
        self.contentView.addSubview(self.pictureView)
        self.contentView.addSubview(self.titleLabel)
        self.activityView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.pictureView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func updateTitleToCenter() {
        self.titleLabel.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    lazy var contentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.addRounded(radius: 8)
        
        return view
        
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        
        let view = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2;
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        return label
    }()
    
    lazy var pictureView: UIImageView = {
        
        let view = UIImageView()
        
        return view
    }()
    
}
