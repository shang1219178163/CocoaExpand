//
//  NSColor+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc public extension NSColor{
    private struct AssociateKeys {
        static var theme   = "NSColor" + "theme"
    }
    
    convenience init(r: Int = 0, g: Int = 0, b: Int = 0, a: CGFloat = 1) {
         assert(r >= 0 && r <= 255, "Invalid red component")
         assert(g >= 0 && g <= 255, "Invalid green component")
         assert(b >= 0 && b <= 255, "Invalid blue component")
         self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
    }
    
    /// [源]0x开头的16进制Int数字(无#前缀十六进制数表示，开头就是0x)
    static func hexValue(_ hex: Int, a: CGFloat = 1.0) -> NSColor {
        return NSColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: a)
    }
    
    //MARK: - -属性
    static var random: NSColor {
        return NSColor.randomColor();
    }
    
    static var theme: NSColor {
        get{
            if let obj = objc_getAssociatedObject(self,  &AssociateKeys.theme) as? NSColor {
                return obj;
            }
            return NSColor.hexValue(0x0082e0)
        }
        set{
            objc_setAssociatedObject(self,  &AssociateKeys.theme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 通用背景色
    static var background: NSColor {
        return NSColor.hexValue(0xe9e9e9);
    }
    
    /// 半透明蒙版
    static var dim: NSColor {
        return NSColor(white: 0, alpha: 0.2)
    }
    
    /// 线条默认颜色(同cell分割线颜色)
    static var line: NSColor {
//        return NSColor.hexValue(0xe0e0e0);
        return NSColor.hexValue(0xe4e4e4);
    }
    
    static var excel: NSColor {
        return NSColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0);
    }
    /// 青蓝
    static var lightBlue: NSColor {
        return NSColor.hexValue(0x29B5FE);
    }
    /// 亮橙
    static var lightOrange: NSColor {
        return NSColor.hexValue(0xFFBB50);
    }
    /// 浅绿
    static var lightGreen: NSColor {
        return NSColor.hexValue(0x1AC756);
    }
    /// 浅红
    static var lightRed: NSColor {
        return NSColor.hexValue(0xFA6D5B);
    }
    
    static var textColor3: NSColor {
        return NSColor.hexValue(0x333333);
    }
    
    static var textColor6: NSColor {
        return NSColor.hexValue(0x666666);
    }
    
    static var textColor9: NSColor {
        return NSColor.hexValue(0x999999);
    }
    
    //MARK: - -方法
    /// [源]十六进制颜色字符串
    static func hex(_ hex: String, a: CGFloat = 1.0) -> NSColor {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased();
        if cString.hasPrefix("#") {
            let index = cString.index(cString.startIndex, offsetBy:1);
            cString = String(cString[index...]);
        } else if cString.hasPrefix("0X") {
            let index = cString.index(cString.startIndex, offsetBy:2);
            cString = String(cString[index...]);
        }
        
        if cString.count != 6 {
            return .red;
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2);
        let rString = String(cString[..<rIndex]);
        
        let otherString = String(cString[rIndex...]);
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2);
        let gString = String(otherString[..<gIndex]);
        
        let bIndex = cString.index(cString.endIndex, offsetBy: -2);
        let bString = String(cString[bIndex...]);
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r);
        Scanner(string: gString).scanHexInt32(&g);
        Scanner(string: bString).scanHexInt32(&b);
        
        //        print(hex,rString,gString,bString,otherString)
        return NSColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a);
    }
    
    static func randomColor() -> NSColor {
        let r = arc4random_uniform(256);
        let g = arc4random_uniform(256);
        let b = arc4random_uniform(256);
        return NSColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1.0));
    }
    
    /// 两个颜色是否相等
    func equalTo(_ c2: NSColor) -> Bool{
        // some kind of weird rounding made the colors unequal so had to compare like this
        let c1 = self;
        var red: CGFloat = 0
        var green: CGFloat  = 0
        var blue: CGFloat = 0
        var alpha: CGFloat  = 0
        c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2: CGFloat = 0
        var green2: CGFloat  = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat  = 0
        c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return (Int(red*255) == Int(red*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue*255))
    }
}

