//
//  NSControl+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc extension NSControl{

    
    public func addTarget(_ target: AnyObject?, action: Selector?, on mask: NSEvent.EventTypeMask = .leftMouseDown) {
        self.target = target;
        self.action = action;
        sendAction(on: mask)
    }
    /// 闭包回调
    public func addActionHandler(_ handler: @escaping (NSControl) -> Void) {
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        target = self;
        action = #selector(p_invoke(_:));
    }
    /// 闭包回调(NSSegmentedControl 专用)
    public func addActionHandler(_ handler: @escaping (NSControl) -> Void, trackingMode: NSSegmentedControl.SwitchTracking) {
        target = self;
        action = #selector(p_invoke(_:));
        if let segmentCtl = self as? NSSegmentedControl {
            segmentCtl.trackingMode = trackingMode;
        }
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    private func p_invoke(_ sender: NSControl) {
        if let handler = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!) as? ((NSControl) -> Void) {
            handler(sender);
        }
    }
    
    
}
