//
//  RowModelType.swift
//  TableViewOptimization
//
//  Created by 陈琪 on 2018/3/30.
//  Copyright © 2018年 carisok. All rights reserved.
//

import Foundation
import UIKit

public protocol RowModelType {
    var rowValue: Any { get }
    var identifier: String { get }
    var height: CGFloat? {get}
    init(original: Self, rowValue: Any, reuseIdentifier: String)
}

extension RowModelType {
    public func getCacheKey(indexPath: IndexPath) -> String {
       return "unique-id-\(indexPath.section)-\(indexPath.row)"
    }
}


