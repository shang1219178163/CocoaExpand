//
//  NSAlert+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSAlert {

    static func create(_ title: String, message: String, btnTitles: [String]) -> Self {
        let alert = self.init()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        for e in btnTitles {
            alert.addButton(withTitle: e)
        }
        return alert 
    }
    
    static func show(_ title: String, message: String, btnTitles: [String], window: NSWindow) {
        let alert = Self.create(title, message: message, btnTitles: btnTitles)
        alert.beginSheetModal(for: window) { (returnCode) in
            DDLog(returnCode)
        }
    }
    /// ❌提示
    static func show(error: NSError) {
        let alert = NSAlert(error: error)
        alert.runModal()
    }
    
}
