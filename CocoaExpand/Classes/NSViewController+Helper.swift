//
//  NSViewController+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/23.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSViewController {

    /// 新增子控制器
    func addChildVC(_ controller: NSViewController) {
        controller.view.frame = self.view.bounds
        addChild(controller)
        view.addSubview(controller.view)
    }
    
    /// 控制器移除
    func removeChildVC() {
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
