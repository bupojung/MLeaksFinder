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
    @objc static var resourceMap = [String: Int]()
    private static func composeKey(of object: AnyObject) -> String {
        return NSStringFromClass(type(of: object)) + String(format: "[%x]", object.hash ?? 0)
    }
    @objc public static func total() -> Int {
        return Int(Resources.total)
    }
    @objc public static func set(resouceCount: Int, object: AnyObject) {
        let key = composeKey(of: object)
        resourceMap[key] = resouceCount
    }
    @objc public static func get(resouceCountOf object: AnyObject) -> Int {
        let key = composeKey(of: object)
        return resourceMap[key] ?? -1
    }
    
    @objc public static func assetResourceNotDealloc(object: AnyObject) {
        let key = composeKey(of: object)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let pre = resourceMap[key], pre < total() {
                resourceMap.removeValue(forKey: key)
                print("Possibly Memory Leak.\n \(key) Cause RxSwift Resource increase.\n preTotal:\(pre), curTotal:\(total())")
            }
        }
    }
}
