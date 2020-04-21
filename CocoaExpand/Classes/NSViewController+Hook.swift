//
//  NSViewController+Hook.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/4/4.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSViewController{
    override class func initializeMethod() {
        super.initializeMethod()
        
        if self != NSViewController.self {
            return
        }
        
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))";
        DispatchQueue.once(token: onceToken) {
            let oriSel = #selector(present(_:asPopoverRelativeTo:of:preferredEdge:behavior:))
            let repSel = #selector(hook_present(_:asPopoverRelativeTo:of:preferredEdge:behavior:))
            _ = hookInstanceMethod(of: oriSel, with: repSel)
            
//            let oriSel1 = #selector(dismiss(_:))
//            let repSel1 = #selector(hook_dismiss(_:))
//            _ = hookInstanceMethod(of: oriSel1, with: repSel1)
        }
        
    }
    
//    private func hook_dismiss(_ viewController: NSViewController){
//        if presentingViewController == nil {
//            return
//        }
//        hook_dismiss(self)
//    }
    
    private func hook_present(_ viewController: NSViewController, asPopoverRelativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge, behavior: NSPopover.Behavior){
        if viewController.presentingViewController != nil {
            dismiss(viewController)
            return
        }
        
        hook_present(viewController, asPopoverRelativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge, behavior: behavior)
    }


}
