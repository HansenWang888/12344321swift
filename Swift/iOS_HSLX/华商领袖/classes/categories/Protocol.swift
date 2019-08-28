//
//  Protocol.swift
//  华商领袖
//
//  Created by hansen on 2019/5/16.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import Foundation

protocol ModelProtocol {
    
    func getCellHeight() -> CGFloat;
    
}
protocol CellProtocal {
    
    func setModel(_ model: Any);
    
}

