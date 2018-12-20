//
//  RxSwiftResources.swift
//  MLeaksFinder
//
//  Created by bupozhuang on 2018/12/19.
//  Copyright © 2018 zeposhe. All rights reserved.
//

import Foundation
import RxSwift


@objc
public class RxSwiftResources: NSObject {
    @objc public static let shared = RxSwiftResources()
    @objc private var resourceMap = [String: Int]()
    @objc private var lastKey = ""
    private func composeKey(of object: AnyObject) -> String {
        return NSStringFromClass(type(of: object)) + String(format: "[%x]", object.hash ?? 0)
    }
    
    @objc private func checkResource(key: String) {
        print("Current Resources Total:\(total())")
        if let pre = resourceMap[key], pre < total() {
            print("Possibly Memory Leak.\n \(key) Cause RxSwift Resource increase.\n preTotal:\(pre), curTotal:\(total())")
        }
        resourceMap.removeValue(forKey: key)
        
    }
    
    @objc private func total() -> Int {
        return Int(Resources.total)
    }
    @objc public func snapshot(object: AnyObject) {
        let key = composeKey(of: object)
        resourceMap.removeValue(forKey: lastKey)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        resourceMap[key] = total()
        print("resourceMap:\(resourceMap.count)")
    }
    
    @objc public func assetResourceNotDealloc(object: AnyObject) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let key = composeKey(of: object)
        lastKey = key
        self.perform(#selector(checkResource(key:)), with: key, afterDelay: 2.0)
        
    }
    
    
}
