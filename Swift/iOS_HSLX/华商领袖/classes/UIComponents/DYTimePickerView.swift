//
//  DYTimePickerView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/18.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

class DYTimePickerView: DYPickerView {


    
    var dateFormat: String = "YYYY-MM-dd HH:mm";
    private var selectDateStr: String?
    init(_ title: String) {
        super.init()
        self.title = title;
        self.setPicker(self.picker);
        self.picker.addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged);
        let dateFormat = DateFormatter.init();
        dateFormat.dateFormat = self.dateFormat;
        self.selectDateStr = dateFormat.string(from: self.picker.date);
    }
    
    @objc private func dateChanged() {
        
        let dateFormat = DateFormatter.init();
        dateFormat.dateFormat = self.dateFormat;
        self.selectDateStr = dateFormat.string(from: self.picker.date);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func confirmBtnClick() {
        self.compeletedBlock?([self.selectDateStr ?? ""]);
        super.confirmBtnClick();
    }
    
    private lazy var picker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = UIDatePicker.Mode.dateAndTime;
        view.locale = Locale.init(identifier: "zh_CN");
        view.calendar = Calendar.current;
        view.timeZone = TimeZone.current;
        view.date = Date.init(timeIntervalSinceNow: 100);
        return view;
    }()



}
