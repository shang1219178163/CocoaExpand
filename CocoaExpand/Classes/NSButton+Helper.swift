//
//  NSButton+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/23.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSButton {

    static func create(_ rect: CGRect) -> Self {
        let view: NSButton = self.init(frame: rect);
        view.autoresizingMask = [.width, .height]
        view.bezelStyle = .regularSquare
        
        if #available(macOS 10.12.2, *) {
            view.bezelColor = NSColor.lightGreen
        }

        return view as! Self;
    }
    
    func setTitleColor(_ color: NSColor, font: CGFloat = 15) {
        let attDic = NSAttributedString.attrDict(font, textColor: color)
        self.attributedTitle = NSAttributedString(string: title, attributes: attDic)
    }
}
