//
//  NSFont+Hook.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/25.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa


@objc public extension NSFont{
    override class func initializeMethod() {
        super.initializeMethod();
        if self != NSFont.self {
            return
        }
        
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))";
        DispatchQueue.once(token: onceToken) {
            let oriSel = #selector(systemFont(ofSize:))
            let repSel = #selector(hook_systemFont(ofSize:))
            _ = swizzleMethodInstance(NSFont.self, origSel: oriSel, replSel: repSel)
            
        }
    }
    
    private class func hook_systemFont(ofSize fontSize: CGFloat) -> NSFont{
        return NSFont(name: NSFont.kPingFangRegular, size: fontSize)!
    }

}

@objc public extension NSFont{
    static let kPingFang           = "PingFang SC";
    static let kPingFangMedium     = "PingFangSC-Medium";
    static let kPingFangSemibold   = "PingFangSC-Semibold";
    static let kPingFangLight      = "PingFangSC-Light";
    static let kPingFangUltralight = "PingFangSC-Ultralight";
    static let kPingFangRegular    = "PingFangSC-Regular";
    static let kPingFangThin       = "PingFangSC-Thin";

}
