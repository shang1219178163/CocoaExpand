
//
//  NSObject+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/28.
//  Copyright © 2018年 BN. All rights reserved.
//

import Cocoa

@objc public extension NSObject{
    private struct AssociateKeys {
        static var runtimeKey   = "NSObject" + "runtimeKey"
    }
    /// 动态属性关联key
    var runtimeKey: UnsafeRawPointer {
        get {
            return objc_getAssociatedObject(self, &AssociateKeys.runtimeKey) as! UnsafeRawPointer
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.runtimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }

    /// 类的字符串名称
    static var identifier: String{
        return String(describing: self)
    }

    ///遍历成员变量列表
    func enumerateIvars(_ block: @escaping ((Ivar, String, Any?)->Void)) {
        var count: UInt32 = 0
        guard let list = class_copyIvarList(self.classForCoder, &count) else { return }
        defer {
            free(list)// 释放c语言对象
        }

        for i in 0..<Int(count) {
            let ivar = list[i]
            //转换成String字符串
            guard let name = ivar_getName(ivar),
                let strName = String(cString: name, encoding: String.Encoding.utf8) else {
                //继续下一次遍历
                continue
            }
            //利用kvc 取值
            let value = self.value(forKey: strName)
            block(ivar, strName, value)
        }
    }
    ///遍历属性列表
    func enumeratePropertys(_ block: @escaping ((objc_property_t, String, Any?)->Void)) {
        var count: UInt32 = 0
        guard let list = class_copyPropertyList(self.classForCoder, &count) else { return }
        defer {
            free(list)// 释放c语言对象
        }
        
        for i in 0..<Int(count) {
            let property: objc_property_t = list[i]
            //获取成员变量的名称 -> c语言字符串
            let name = property_getName(property)
            //转换成String字符串
            guard let strName = String(cString: name, encoding: String.Encoding.utf8) else {
                //继续下一次遍历
                continue
            }
            //利用kvc 取值
            let value = self.value(forKey: strName)
            block(property, strName, value)
        }
    }
    ///遍历方法列表
    func enumerateMethods(_ block: @escaping ((Method, String)->Void)) {
        var count: UInt32 = 0
        guard let list = class_copyMethodList(self.classForCoder, &count) else { return }
        defer {
            free(list)// 释放c语言对象
        }

        for i in 0..<Int(count) {
            let method: Method = list[i]
            //获取成员变量的名称 -> c语言字符串
            let name: Selector = method_getName(method)
            //转换成String字符串
            let strName = NSStringFromSelector(name)
            block(method, strName)
        }
    }
    ///遍历遵循的协议列表
    func enumerateProtocols(_ block: @escaping ((Protocol, String)->Void)) {
        var count: UInt32 = 0
        guard let list = class_copyProtocolList(self.classForCoder, &count) else { return }

        for i in 0..<Int(count) {
            let proto: Protocol = list[i]
            //获取成员变量的名称 -> c语言字符串
            let name = protocol_getName(proto)
            //转换成String字符串
            guard let strName = String(cString: name, encoding: String.Encoding.utf8) else {
                //继续下一次遍历
                continue
            }
            block(proto, strName)
        }
    }

    /// 模型自动编码
    func se_encode(with aCoder: NSCoder) {
        enumeratePropertys { (property, name, value) in
            guard let value = self.value(forKey: name) else { return }
            //进行编码
            aCoder.encode(value, forKey: name)
        }
    }
    
    /// 模型自动解码
    func se_decode(with aDecoder: NSCoder) {
        enumeratePropertys { (property, name, value) in
            //进行解档取值
            guard let value = aDecoder.decodeObject(forKey: name) else { return }
            //利用kvc给属性赋值
            self.setValue(value, forKeyPath: name)
        }
    }
    /// 字典转模型
    convenience init(dic: [String: Any]) {
        self.init();
        self.setValuesForKeys(dic)
    }
    ///详情模型转字典(不支持嵌套)
    func toDictionary() -> [AnyHashable : Any] {
//        let classType: NSObject.Type = type(of: self)
//        var dic: [AnyHashable : Any] = [:]
//
//        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
//        if let properties = class_copyPropertyList(classType, count) {
//            for i in 0 ..< count.pointee {
//                let name = String(cString: property_getName(properties.advanced(by: Int(i)).pointee))
//                if let propertyName = String(utf8String: name) {
//                    let propertyValue = value(forKey: propertyName)
//                    if propertyValue != nil {
//                        dic[propertyName] = propertyValue
//                    }
//                }
//            }
//            free(properties)
//        }
        var dic: [AnyHashable : Any] = [:]
        self.enumeratePropertys { (property, name, value) in
            dic[name] = value ?? ""
        }
        return dic
    }
    
    func synchronized(_ lock: AnyObject, block: () -> Void) {
        objc_sync_enter(lock)
        block()
        objc_sync_exit(lock)
    }
            
    // MARK: - KVC

    /// 返回key对应的值
    func valueText(forKey key: String, defalut: String = "-") -> String{
        if key == "" {
            return "";
        }
        if let result = self.value(forKey: key) {
            return "\(result)" != "" ? "\(result)" : defalut;
        }
        return defalut;
    }
    /// 返回key对应的值
    func valueText(forKeyPath keyPath: String, defalut: String = "-") -> String{
        if keyPath == "" {
            return "";
        }
        if let result = self.value(forKeyPath: keyPath) {
            return "\(result)" != "" ? "\(result)" : defalut;
        }
        return defalut;
    }
    
    // MARK: - 视图相关
    ///  富文本只有同字体大小才能计算高度
    func sizeWithText(_ text: String = "", font: CGFloat = 15, width: CGFloat) -> CGSize {
        let attDic = NSAttributedString.paraDict(font, textColor: .black, alignment: .left);
        let options: NSString.DrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        var size = text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: options , attributes: attDic, context: nil).size;
        size.width = ceil(size.width);
        size.height = ceil(size.height);
        return size;
    }
    
//    /// 密集小视图的尺寸布局
//    func itemSize(_ items: [String], numberOfRow: Int, width: CGFloat = NSScreen.sizeWidth, itemHeight: CGFloat = 60, padding: CGFloat = kPadding) -> CGSize {
//        let rowCount = items.count % numberOfRow == 0 ? items.count/numberOfRow : items.count/numberOfRow + 1
////        let tmp = CGFloat(numberOfRow) - 1.0
////        let itemWith = (width - tmp*padding)/CGFloat(numberOfRow)
////        let tmpHeight = itemHeight <= 0.0 ? itemWith : itemHeight;
//        let height = CGFloat(rowCount) * itemHeight + CGFloat(rowCount) - 1.0 * padding
//        let size = CGSize(width: width, height: height)
//        return size
//    }
//    
//    /// 标题前缀差异化显示
//    func getAttringByPrefix(_ prefix: String!, content: String!, isMust: Bool = false) -> NSAttributedString {
//        let string = content.hasPrefix(prefix) == true ? content : prefix + content
//        let colorMust = isMust == true ? NSColor.red : NSColor.clear
//        let attString = NSAttributedString.attString(string, textTaps: [prefix], font: 15, tapFont: 15, color: .black, tapColor: colorMust, alignment: .left)
//        return attString
//    }

}


