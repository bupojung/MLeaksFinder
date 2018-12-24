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
    
    @objc private func checkResource(targetVCName: String) {
        snapshotResourceCount(targetVCName)
        for info in infoMap.values {
            if info.checkLeaks() {
                print(info.leakInfo)
                infoMap.removeValue(forKey: info.key)
            }
        }
    }
    
    @objc private func total() -> Int {
        return Int(Resources.total)
    }
    
    @objc public func snapshotPreVC() {
        if let curVC = UIApplication.shared.topMostViewController(), let preVC = curVC.preViewController() {
            let curVCName = NSStringFromClass(type(of: curVC))
            let preVCName = NSStringFromClass(type(of: preVC))
            print("bupo pre className \(preVCName)")
            if infoMap["\(preVCName)->\(curVCName)"] != nil {
                return
            }
            let info = ResourcesInfo(targetVCName: curVCName, curVCName: preVCName)
            infoMap[info.key] = info
        }

    }
    
    @objc public func snapshotResourceCount(_ targetVCName: String) {
        if let preVC = UIApplication.shared.topMostViewController() {
            let preVCName = NSStringFromClass(type(of: preVC))
            if let info = infoMap["\(preVCName)->\(targetVCName)"] {
                if info.preCount < 0 {
                    info.preCount = total()
                } else {
                    info.curCount = total()
                }
            }
        }
    }
    
    @objc public func assetResourceNotDealloc(object: AnyObject) {
        let className = NSStringFromClass(type(of: object))
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(checkResource(targetVCName:)), with: className, afterDelay: 2.0)
        
    }
    
    
}


extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        if let split = self as? UISplitViewController {
            return split.viewControllers.last?.topMostViewController() ?? split
        }
        return self
    }
    
    func preViewController() -> UIViewController? {
        if let presenting = self.presentingViewController {
            return presenting
        }
        
        if let navigation = self.navigationController {
            let count = navigation.viewControllers.count
            return count > 1 ? navigation.viewControllers[count - 2] : nil
        }
        
        if let split = self.splitViewController {
            let count = split.viewControllers.count
            return count > 1 ? split.viewControllers[count - 2] : nil
        }
        
        return nil
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
