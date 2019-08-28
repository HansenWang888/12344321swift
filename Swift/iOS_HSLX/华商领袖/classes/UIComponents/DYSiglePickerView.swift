//
//  DYSiglePickerView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/18.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYSiglePickerView: DYPickerView {

    private var dataSources: [String] = [];
    var currentSelected: Int = 0;

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init(_ title: String, dataSources: [String]) {
        super.init()
        self.title = title;
        self.dataSources = dataSources;
        self.setPicker(self.picker);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func confirmBtnClick() {
        if (self.compeletedBlock != nil) {
            self.compeletedBlock!([self.currentSelected, self.dataSources[self.currentSelected]])
        }
        super.confirmBtnClick();
    }
    
    
    private lazy var picker: UIPickerView = {
        
        let view  = UIPickerView.init()
        view.delegate = self;
        view.dataSource = self;
        
        return view
    }()
}
extension DYSiglePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSources.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSources[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSelected = row
    }
    
    
}
