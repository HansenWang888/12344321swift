//
//  DYRichTextVC.swift
//  华商领袖
//
//  Created by hansen on 2019/5/17.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYRichTextVC: UIViewController {

    
    
    var editFinished: ((_ content: String) -> Void)?
    var content: String?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "富文本编辑";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarbtnClick))

        // Do any additional setup after loading the view.
        self.setupSubviews();
        self.distributionSubview();
        
    }
    
    
    @objc private func rightBarbtnClick() {
        
        self.editFinished?(self.textView.text);
        self.navigationController?.popViewController(animated: true);
    }
    private func setupSubviews() {
        
        self.view.addSubview(self.textView);

        let attr = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html];
        self.textView.attributedText = try? NSAttributedString.init(data: (self.content ?? "").data(using: .unicode)!, options: attr, documentAttributes: nil)
        
    }
    private func distributionSubview() {
        self.textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    
    private lazy var textView: UITextView = {
        let view = UITextView();
        
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
