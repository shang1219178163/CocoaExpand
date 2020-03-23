//
//  NSTableCellView+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSTableCellView {

    /// 复用NSTableCellView
    static func makeView(tableView: NSTableView, identifier: String = String(describing: self), owner: Any) -> Self {
        let itemIdentifier = NSUserInterfaceItemIdentifier(rawValue: identifier);
        if let view = tableView.makeView(withIdentifier: itemIdentifier, owner: owner) as? Self {
            return view;
        }
        let cellView = Self.init()
        cellView.identifier = itemIdentifier;
        cellView.wantsLayer = true;
        return cellView;
    }
    
//    static func makeView(tableView: NSTableView, identifier: String = String(describing: self), owner: Any) -> Self {
//
//        let itemIdentifier = NSUserInterfaceItemIdentifier(rawValue: identifier);
//        var view = tableView.makeView(withIdentifier: itemIdentifier, owner: self) as? Self
//        if view == nil {
//            view = Self.init()
//            view!.identifier = itemIdentifier;
//        }
//        view!.wantsLayer = true;
//        return view!;
//    }
    
    func udpateSelectionHighlight() {
        textField?.textColor = backgroundStyle == .dark ? NSColor.white : NSColor.black;
    }
    
}

public extension NSTableView {
    /// makeView
    final func makeView<T: NSTableCellView>(for cellType: T.Type, identifier: String = String(describing: T.self), style: NSTableView.RowSizeStyle = .default) -> T {
        if let view: NSTableCellView = makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: T.self) as? T {
            return view as! T;
        }
        let cellView = T.init()
        cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier);
        cellView.wantsLayer = true;
        return cellView;
    }
}
