//
//  TableView+CacheInvalidation.swift
//  TableViewOptimization
//
//  Created by 陈琪 on 2018/4/10.
//  Copyright © 2018年 carisok. All rights reserved.
//

import UIKit

private var hasSwizzled = false

extension UITableView {
    
    final public class func doSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        // 所有有可能要修改height缓存的方法
        let selectors = [
            #selector(UITableView.reloadData),
            #selector(UITableView.insertSections(_:with:)),
            #selector(UITableView.deleteSections(_:with:)),
            #selector(UITableView.reloadSections(_:with:)),
            #selector(UICollectionView.moveSection(_:toSection:)),
            #selector(UITableView.insertRows(at:with:)),
            #selector(UITableView.deleteRows(at:with:)),
            #selector(UITableView.reloadRows(at:with:)),
            #selector(UITableView.moveRow(at:to:))
        ]
        // 对所有method转换成我们自己写的method
        for index in 0..<selectors.count{
            
            let originalSelector = selectors[index]
            let swizzledSelector = NSSelectorFromString("op_\(NSStringFromSelector(originalSelector))")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            
        }
    }
    
    func op_reloadData() {
        if (self.keyedHeigthCache?.autoInvalidateEnabled)! {
            self.keyedHeigthCache?.heightByIndexPathForPortrait.removeAll()
        }
        self.op_reloadData()
    }
    
    func  op_insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        
    }
    
    func op_deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        
    }
    
    func op_reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        
    }
    
    func op_moveSection(_ section: Int, toSection newSection: Int) {
        
    }
    
    func op_insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        
    }
    
    func op_deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        
    }
    
    func op_reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        
    }
    
    func op_moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        
    }
}
