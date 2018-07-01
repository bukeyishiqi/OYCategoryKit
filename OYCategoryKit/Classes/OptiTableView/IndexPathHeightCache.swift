//
//  IndexPathHeightCache.swift
//  TableViewOptimization
//
//  Created by 陈琪 on 2018/4/8.
//  Copyright © 2018年 carisok. All rights reserved.
//

import Foundation

public class IndexPathHeightCache: NSObject, NSCopying {
    
    public var autoInvalidateEnabled: Bool = true
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = IndexPathHeightCache()
        theCopy.heightsByKeyForPortrait = self.heightsByKeyForPortrait
        return theCopy
    }

    var heightsByKeyForPortrait: [String: NSNumber] = [String: NSNumber]()
    var heightByIndexPathForPortrait: [[NSNumber]] = []
    
    
    // Key
    func exsitHeight(forKey key: String) -> Bool {
        let number = self.heightsByKeyForPortrait[key]
        
        guard let num = number else {
            return false
        }
        return !num.isEqual(to: -1)
    }
    
    func cacheHeight(height: NSNumber, forKey key: String) {
        self.heightsByKeyForPortrait[key] = height
    }
    
    func height(forKey key: String) -> NSNumber {
        return self.heightsByKeyForPortrait[key]!
    }
    
    func invalidateAllHeightCache(forKey key: String) {
        self.heightsByKeyForPortrait[key] = -1
    }
    
    func invalidateAllHeightCache() {
        self.heightsByKeyForPortrait.removeAll()
        self.heightByIndexPathForPortrait.removeAll()
    }
    
    // IndexPath
    func exsitHeight(forIndexPath indexPath: IndexPath) -> Bool {
        self.buildHeightCachesAtIndexPathsIfNeeded([indexPath])

        let number = self.heightByIndexPathForPortrait[indexPath.section][indexPath.row]
        
        return !number.isEqual(to: -1)
    }
    
    func cacheHeight(height: NSNumber, forIndexPath indexPath: IndexPath) {
        self.buildHeightCachesAtIndexPathsIfNeeded([indexPath])
        self.heightByIndexPathForPortrait[indexPath.section][indexPath.row] = height
    }
    
    func height(forIndexPath indexPath: IndexPath) -> NSNumber {
        self.buildHeightCachesAtIndexPathsIfNeeded([indexPath])
        return self.heightByIndexPathForPortrait[indexPath.section][indexPath.row]
    }
    
    func invalidateAllHeightCache(forIndexPath indexPath: IndexPath) {
        self.buildHeightCachesAtIndexPathsIfNeeded([indexPath])

        self.heightByIndexPathForPortrait[indexPath.section][indexPath.row] = -1
    }
    
    private func buildHeightCachesAtIndexPathsIfNeeded(_ indexPaths:[IndexPath]){
        guard indexPaths.count > 0 else { return }
        indexPaths.forEach { (indexPath) -> () in
            //如果section 数组里面还没有 创建一个对象的空数组
            if indexPath.section >= self.heightByIndexPathForPortrait.count{
                self.heightByIndexPathForPortrait.insert([], at: indexPath.section)
            }
            
            var rows = self.heightByIndexPathForPortrait[indexPath.section]
            //如果对应的row不存在 创建一个并标记为没有被cache
            if indexPath.row >= rows.count {
                rows.insert(-1, at: indexPath.row)
            }
            self.heightByIndexPathForPortrait[indexPath.section] = rows
        }
        
    }
}
