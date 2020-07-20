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
    
    ///创建 NSButton 集合视图
    static func createGroupView(_ rect: CGRect, list: [String], numberOfRow: Int = 4, padding: CGFloat = kPadding, target: Any?, action: Selector?, inView: NSView) -> [NSButton] {
                
        if CGRect.zero.equalTo(rect) {
            var btns: [NSButton] = []
            for (i,value) in list.enumerated() {
                let sender = NSButton(title: value, target: target, action: action)
                sender.bezelStyle = .regularSquare
                sender.lineBreakMode = .byCharWrapping
                sender.tag = i
                inView.addSubview(sender);
                btns.append(sender)
            }
            return btns
        }
        
        let rowCount: Int = list.count % numberOfRow == 0 ? list.count/numberOfRow : list.count/numberOfRow + 1;
        let itemWidth = (rect.width - CGFloat(numberOfRow - 1)*padding)/CGFloat(numberOfRow)
        let itemHeight = (rect.height - CGFloat(rowCount - 1)*padding)/CGFloat(rowCount)
        
        var btns: [NSButton] = []
        for (i,value) in list.enumerated() {
            let x = CGFloat(i % numberOfRow) * (itemWidth + padding);
            let y = CGFloat(i / numberOfRow) * (itemHeight + padding);
            let itemRect = CGRect(x: x, y: y, width: itemWidth, height: itemHeight);
            
            let sender = NSButton(title: value, target: target, action: action)
            sender.frame = itemRect
            sender.bezelStyle = .regularSquare
            sender.lineBreakMode = .byCharWrapping
            sender.tag = i
            inView.addSubview(sender);
            btns.append(sender)
        }
        return btns
    }
    ///更新 NSButton 集合视图
    static func setupConstraint(_ rect: CGRect, items: [NSButton], numberOfRow: Int = 4, padding: CGFloat = kPadding) {
        if items.count == 0 || rect.width <= 0 {
            return;
        }
        
        let rowCount = items.count % numberOfRow == 0 ? items.count/numberOfRow : items.count/numberOfRow + 1;
        let itemWidth = (rect.width - CGFloat(numberOfRow - 1)*padding)/CGFloat(numberOfRow)
        let itemHeight = (rect.height - CGFloat(rowCount - 1)*padding)/CGFloat(rowCount)
        
        for e in items.enumerated() {
            let x = CGFloat(e.offset % numberOfRow) * (itemWidth + padding)
            let y = CGFloat(e.offset / numberOfRow) * (itemHeight + padding)
            let rect = CGRect(x: x, y: y, width: ceil(itemWidth), height: itemHeight)
            
            let sender = e.element;
            sender.frame = rect;
        }
    }
    
    /// 验证码倒计时显示
    func timerStart(_ interval: Int = 60) {
        var time = interval
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {

            time -= 1
            DispatchQueue.main.async {
                self.isEnabled = time <= 0;
                if time > 0 {
                    self.title = "剩余\(time)s"
                    return;
                }
                codeTimer.cancel()
                self.title = "发送验证码"
            }
        }
        codeTimer.resume()
    }
}
