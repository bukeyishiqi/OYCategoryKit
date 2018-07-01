//
//  TableViewConfiguration.swift
//  TableViewOptimization
//
//  Created by 陈琪 on 2018/3/29.
//  Copyright © 2018年 carisok. All rights reserved.
//

import Foundation
import UIKit

public class TableViewConfiguration<S: SectionModelType>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    public typealias I = S.Item
    public typealias CellContentConfig = (UITableViewCell?, I) -> Void
    public typealias CellFactory = (TableViewConfiguration, UITableView, IndexPath, I) -> UITableViewCell
    public typealias CellAction = (UITableView, IndexPath, I) -> Void
    
    public var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
//        self.tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    private var _sectionModels:[S] = []
    
    public subscript(section: Int) -> S {
        let sectionModel = self._sectionModels[section]
        return S(original: sectionModel, items: sectionModel.items)
    }
    
    public func setSections(_ sections: [S]) {
        self._sectionModels = sections
        tableView.reloadData()
    }
    
    public var configureCell: CellFactory! = nil
    public var configCellContent: CellContentConfig! = nil
    
    public var actionForCell: CellAction! = nil
    
    public var heightForHeaderInSection:((TableViewConfiguration, Int) -> CGFloat?)?
    public var heightForFooterInSection:((TableViewConfiguration, Int) -> CGFloat?)?
    
    public var titleForHeaderInSection:((TableViewConfiguration, Int) -> String?)?
    public var titleForFooterInSection: ((TableViewConfiguration, Int) -> String?)?
    
    public var viewForHeaderInSection:((TableViewConfiguration, Int) -> UIView?)?
    public var viewForFooterInSection:((TableViewConfiguration, Int) -> UIView?)?
    
    
    // UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return _sectionModels.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard _sectionModels.count > section else { return 0 }
        return _sectionModels[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return configureCell(self, tableView, indexPath, _sectionModels[indexPath.section].items[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 注：此处缓存高度
        let item = _sectionModels[indexPath.section].items[indexPath.row]
        if item.height != 0 {
            return item.height!
        }
        
        return tableView.heightForCell(
            identifier: item.identifier,
            cacheByKey: item.getCacheKey(indexPath: indexPath),
            configure:{cell in
                configCellContent(cell, item)
        })
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if actionForCell != nil {
            actionForCell(tableView, indexPath, _sectionModels[indexPath.section].items[indexPath.row])
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection?(self, section)
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection?(self, section)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let height = heightForHeaderInSection?(self, section)  {
            return height
        }
        
        return 0
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let height = heightForFooterInSection?(self, section)  {
            return height
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection?(self, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection?(self, section)
    }
}




