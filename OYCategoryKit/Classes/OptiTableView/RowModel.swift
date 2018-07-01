//
//  RowModel.swift
//  TableViewOptimization
//
//  Created by 陈琪 on 2018/4/12.
//  Copyright © 2018年 carisok. All rights reserved.
//

import Foundation
import UIKit

struct RowModel {
    // 行对应model值
    var rowValue: Any
    
    var reuseIdentifier: String
    
    var rowHeight: CGFloat?
    
    init(rowValue: Any, reuseIdentifier: String, height: CGFloat? = 0) {
        self.rowValue = rowValue
        self.reuseIdentifier = reuseIdentifier
        self.rowHeight = height
    }
}

extension RowModel: RowModelType {
    
    var identifier: String {
        return self.reuseIdentifier
    }
    
    var height: CGFloat? {
        return self.rowHeight
    }
    
    
    init(original: RowModel, rowValue: Any, reuseIdentifier: String) {
        self = original
        self.rowValue = rowValue
        self.reuseIdentifier = reuseIdentifier
    }
}
