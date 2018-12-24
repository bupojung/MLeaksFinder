//
//  RxSwiftResources.swift
//
//  Created by bupozhuang on 2018/12/19.
//

import Foundation
import RxSwift


@objc
class ResourcesInfo: NSObject {
    var targetVCName: String
    var curVCName: String
    var preCount: Int = -1
    var curCount: Int = -1
    var key: String {
        return "\(curVCName)->\(targetVCName)"
    }
    
    var leakInfo: String {
        return "\(curVCName)(\(preCount))->\(targetVCName)(\(curCount))"
    }
    init(targetVCName: String, curVCName: String) {
        self.targetVCName = targetVCName
        self.curVCName = curVCName
    }
    
    func checkLeaks() -> Bool {
        if targetVCName.count > 0 && curVCName.count > 0
            && preCount >= 0 && curCount >= 0 {
            if curCount - preCount > 0 {
                return true
            }
        }
        return false
    }
    
}

@objc
public class RxSwiftResources: NSObject {
    @objc public static let shared = RxSwiftResources()
    @objc private var infoMap = [String: ResourcesInfo]()
    
    @objc private func checkResource(with key: String) {
        trackResourceCount(with: key)
        
        for info in infoMap.values {
            if info.checkLeaks() {
                print("Possible Leaks:\(info.leakInfo)")
                infoMap.removeValue(forKey: info.key)
            }
        }
    }
    
    @objc private func total() -> Int {
        return Int(Resources.total)
    }
    
    @objc public func track(curVCName: String, targetVCName: String) {
        if infoMap["\(curVCName)->\(targetVCName)"] != nil {
            return
        }
        let info = ResourcesInfo(targetVCName: targetVCName, curVCName: curVCName)
        infoMap[info.key] = info
    }
    
    @objc public func trackResourceCount(with key: String) {
        if let info = infoMap[key] {
            if info.preCount < 0 {
                info.preCount = total()
            } else {
                info.curCount = total()
            }
        }
    }
    
    @objc public func assetResourceNotDealloc(curVCName: String, targetVCName: String) {
        let key = "\(curVCName)->\(targetVCName)"
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(checkResource(with:)), with: key, afterDelay: 2.0)
    }
    
    
}
