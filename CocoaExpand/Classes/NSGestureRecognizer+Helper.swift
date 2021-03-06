//
//  NSGestureRecognizer+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSGestureRecognizer {
    private struct AssociateKeys {
        static var funcName   = "NSGestureRecognizer" + "funcName"
        static var closure    = "NSGestureRecognizer" + "closure"
    }
    
//    /// 方法名称(用于自定义)
//    var funcName: String {
//        get {
//            var obj = objc_getAssociatedObject(self, &AssociateKeys.funcName) as? String;
//            if obj == nil {
//                obj = String(describing: self.classForCoder);
//                objc_setAssociatedObject(self, &AssociateKeys.funcName, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//            }
//            return obj!
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociateKeys.funcName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        }
//    }
    /// 闭包回调
    func addAction(_ handler: @escaping ((NSGestureRecognizer) -> Void)) {
        objc_setAssociatedObject(self, &AssociateKeys.closure, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        target = self;
        action = #selector(p_invoke(_:));
    }

    private func p_invoke(_ sender: NSGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &AssociateKeys.closure) as? ((NSGestureRecognizer) -> Void) {
            handler(sender);
        }
    }
    
}

@objc public extension NSClickGestureRecognizer {
    private struct AssociateKeys {
        static var closure    = "NSClickGestureRecognizer" + "closure"
    }
    
    /// 闭包回调
    override func addAction(_ handler: @escaping (NSClickGestureRecognizer) -> Void) {
        objc_setAssociatedObject(self, &AssociateKeys.closure, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        target = self;
        action = #selector(p_invokeClick(_:));
    }

    private func p_invokeClick(_ sender: NSClickGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &AssociateKeys.closure) as? ((NSClickGestureRecognizer) -> Void) {
            handler(sender);
        }
    }
    
}

