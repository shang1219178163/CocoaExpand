//
//  NSSegmentedControl+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/23.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSSegmentedControl {

    var items: [String] {
        get {
            return objc_getAssociatedObject(self, RuntimeKeySelector(#function)) as! [String]
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeySelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            segmentCount = newValue.count;
            selectedSegment = 0;
            for e in newValue.enumerated() {
                self.setLabel(e.element, forSegment: e.offset)
            }
        }
    }
    
    static func create(_ rect: NSRect, items: [Any]) -> Self {
        let control = self.init(frame: rect)
        control.segmentStyle = .texturedRounded
        control.trackingMode = .momentary
        
        control.segmentCount = items.count
        
        let width: CGFloat = rect.width/CGFloat(control.segmentCount)
        for e in items.enumerated() {
            if e.element is NSImage {
                control.setImage((e.element as! NSImage), forSegment: e.offset)
            } else {
                control.setLabel(e.element as! String, forSegment: e.offset)
            }
            control.setWidth(width, forSegment: e.offset)
        }
        return control;
    }
    
}
