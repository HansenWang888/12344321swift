//
//  CreateOpportunityVC.swift
//  华商领袖
//
//  Created by abc on 2019/3/26.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class CreateOpportunityVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    private var dataSources: Array<Dictionary<String, String>> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布商机"
        
        
        
        
        // Do any additional setup after loading the view.
    }


}


extension CreateOpportunityVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    
    
    
}



class CreateOpportunityCell: UITableViewCell {
    
    
    
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        
        
        return label
    }()
    
}
