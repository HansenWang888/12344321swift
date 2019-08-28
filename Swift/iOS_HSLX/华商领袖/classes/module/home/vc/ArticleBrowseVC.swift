//
//  ArticleBrowseVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/21.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit
import WebKit
class ArticleBrowseVC: BaseVC {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var browseBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    var articleID: Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商业见闻";
        self.loadData();
        
        self.view.addSubview(self.webView);
        self.webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.top.equalTo(self.headerView.snp.bottom);
        }
        // Do any additional setup after loading the view.
    }

    
    private func loadData() {
        
        SVProgressHUD.show(withStatus: nil);
        networkArticleID = self.articleID;
        NetWorkRequest(target: HomeNetwork.getArticleInfo) { (result) in
            
            switch result {
            case .successful(let response):
                SVProgressHUD.dismiss();
                let dict = response as! [String : Any]
                let model = ArticleBrowseModel.init(JSON: dict);
                self.titleLabel.text = model?.title;
                self.subTitle.text = model?.copyFrom;
                self.timeLabel.text = Date.getFormdateYMDHM(timeStamp: model!.createTime ?? 0);
                self.browseBtn.setTitle( "浏览 \(model?.hits ?? 0)" , for: UIControl.State.normal);
                self.webView.loadHTMLString(model?.content ?? "", baseURL: nil);
                
                break
                
            case .failure(let errmsg) :
                SVProgressHUD.showError(withStatus: errmsg)
                break
                
            }
        }
//       记录浏览次数
        NetWorkRequest(target: HomeNetwork.articleBrowse(self.articleID)) { (_) in
            
        };
        
    }

    
    private lazy var webView: WKWebView = {
        let view = WKWebView();
        
        return view;
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
