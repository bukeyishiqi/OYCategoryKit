//
//  SectionModelType.swift
//  TableViewOptimization
//
//  Created by 陈琪 on 2018/3/29.
//  Copyright © 2018年 carisok. All rights reserved.
//

import Foundation


public protocol SectionModelType {
    
    associatedtype Item: RowModelType
    
    var items: [Item] { get }
    
    init(original: Self, items: [Item])
    
}
