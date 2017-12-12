//
//  NSDictionary+GetSet.swift
//  mugshotSDKModel
//
//  Created by jackSun on 16/5/17.
//  Copyright © 2016年 junyu. All rights reserved.
//

import Foundation

extension NSDictionary {
    func intForKey(_ key: NSString) -> Int {
        var ret = 0
        if let val: AnyObject = self.object(forKey: key) as AnyObject? {
            ret = val as? Int ?? 0
        }
        return ret
    }
}

extension NSMutableDictionary {
    func setInt(_ val: Int, ForKey key: NSString) {
        self.setObject(val, forKey: key)
    }
}
