//
//  NSTableColumn+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSTableColumn {

    /// 复用NSTableCellView
    static func create(identifier: String = String(describing: self), title: String) -> Self {
       
        let column = self.init(identifier: NSUserInterfaceItemIdentifier(identifier))
        column.title = title;
        column.minWidth = 40;
        column.maxWidth = CGFloat.greatestFiniteMagnitude;
        column.headerToolTip = column.title;
        column.headerCell.alignment = .center;
        
//        column.resizingMask = .userResizingMask;//可手动调整宽度
        
        let sort = NSSortDescriptor(key: column.title, ascending: false, selector: #selector(NSString.localizedCompare(_:)))
        column.sortDescriptorPrototype = sort
        return column;
    }
    
}
