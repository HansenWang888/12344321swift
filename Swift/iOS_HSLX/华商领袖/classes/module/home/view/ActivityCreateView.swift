//
//  ActivityCreateView.swift
//  华商领袖
//
//  Created by abc on 2019/3/26.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class ActivityCreateView: UIView {

    //MARK: ******public********
    var btnClickBlock: ((Int) ->Void)? = nil
    class func initActivityView() -> ActivityCreateView {
        let view = Bundle.main.loadNibNamed("ActivityCreateView", owner: nil, options: nil)?.first as! ActivityCreateView
        
        return view
    }
    class func showCreateView() ->ActivityCreateView {
        let windowView = UIApplication.shared.keyWindow
        let aView = self.initActivityView()
        windowView?.addSubview(aView)
        aView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return aView
    }
  
    //MARK: *******private*******
    @IBOutlet weak var closeBtn: UIButton!
    private func dismissView() {
        
        self.removeFromSuperview()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction private func activityBtnClick(_ sender: UIButton) {
        if self.btnClickBlock != nil {
            self.btnClickBlock!(sender.tag)
        }
        self.dismissView()
      
    }
    @IBAction func closeBtnClick(_ sender: Any) {
        self.dismissView()
    }
    
}
