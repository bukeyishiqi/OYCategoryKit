//
//  SectionModel.swift
//  TableViewOptimization
//
//  Created by 陈琪 on 2018/3/29.
//  Copyright © 2018年 carisok. All rights reserved.
//

import Foundation

struct SectionModel<T: RowModelType> {
    var sectionItems: [T]
}

extension SectionModel: SectionModelType {
  
    typealias Item  = T

    var items: [Item] { return self.sectionItems }

    init(original: SectionModel<T>, items: [T]) {
        self = original
        self.sectionItems = items
    }
}
