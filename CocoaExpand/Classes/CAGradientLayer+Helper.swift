//
//  CAGradientLayer+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/2/26.
//  Copyright © 2019 BN. All rights reserved.
//

import Cocoa

@objc public extension CAGradientLayer{
    private struct AssociateKeys {
        static var defaultColors   = "CAGradientLayer" + "defaultColors"
    }
    
    static func layerRect(_ rect: CGRect = .zero, colors: [Any], start: CGPoint, end: CGPoint) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = rect
        layer.colors = colors
        layer.startPoint = start
        layer.endPoint = end
        
        return layer
    }
    
    static func gradientColor(_ from: NSColor, to: NSColor) -> [Any] {
       return [from.cgColor, to.cgColor]
    }
    
    /// 十六进制字符串
    static func gradientColorHex(_ from: String, fromAlpha: CGFloat, to: String, toAlpha: CGFloat = 1.0) -> [Any] {
        return [NSColor.hex(from, a: fromAlpha).cgColor, NSColor.hex(to, a: toAlpha).cgColor]
    }
    
    /// 0x开头的十六进制数字
    static func gradientColorHexValue(_ from: Int, fromAlpha: CGFloat, to: Int, toAlpha: CGFloat = 1.0) -> [Any] {
        return [NSColor.hexValue(from, a: fromAlpha).cgColor, NSColor.hexValue(to, a: toAlpha).cgColor]
    }
    
    static var defaultColors: [Any] {
        get {
            if let obj = objc_getAssociatedObject(self,  &AssociateKeys.defaultColors) as? [Any] {
                return obj;
            }
            
            let list = [NSColor.hexValue(0x6cda53, a: 0.9).cgColor, NSColor.hexValue(0x1a965a, a: 0.9).cgColor]
                objc_setAssociatedObject(self,  &AssociateKeys.defaultColors, list, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return list
        }
        set {
            objc_setAssociatedObject(self,  &AssociateKeys.defaultColors, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}
