//
//  NSString+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/28.
//  Copyright © 2018年 BN. All rights reserved.
//

import Cocoa
import CommonCrypto

public extension String{
    /// md5字符串
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    /// 是否是"","nil","null"
    var isValid: Bool {
        return !["","nil","null"].contains(self);
    }
    /// Int
    var intValue: Int {
        return Int((self as NSString).integerValue)
    }
    /// Float
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    /// CGFloat
    var cgFloatValue: CGFloat {
        return CGFloat(self.floatValue)
    }
    /// Double
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    /// 为空返回默认值"--"
    var valueText: String {
        return self != "" ? self : "--"
    }
    /// d字符串翻转
    var reverse: String {
        return String(self.reversed())
    }
    /// ->Data
    var jsonData: Data? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data;
    }
    
    /// 字符串->数组/字典
    var objValue: Any? {
        guard let data = self.data(using: .utf8),
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
            else { return nil }
        return json
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
        
    // MARK: -funtions
    func trimmedBy(_ string: String) -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: string))
    }
    
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    /// 大于version
    func isNewer(version: String) -> Bool {
        return (self as NSString).isNewer(version:version)
    }
    /// 等于version
    func isSame(version: String) -> Bool {
        return (self as NSString).isSame(version:version)
    }
    /// 小于version
    func isOlder(version: String) -> Bool {
        return (self as NSString).isOlder(version:version)
    }
    /// 汉字转为拼音
    func transformToPinyin() -> String {
       return (self as NSString).transformToPinyin();
    }
    /// 字符串首位加*
//    func toAsterisk() -> NSAttributedString{
//        return (self as NSString).toAsterisk()
//    }
    
    /// 复制到剪切板
    func copyToPasteboard(_ showTips: Bool) {
        (self as NSString).copyToPasteboard(showTips)
    }
    
    /// 获取前缀
    func getPrefix(with separates: [String]) -> String {
        var reult = ""
        for value in separates {
            if self.contains(value) {
                reult = self.components(separatedBy: value).first!
                break
            }
        }
        return reult;
    }
    
    /// 字符串开始到第index
    func substringTo(_ index: Int) -> String {
        guard index < self.count else {
            assertionFailure("index beyound the length of the string")
            return ""
        }
        
        let theIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[startIndex...theIndex])
    }
    
    /// 从第index个开始到结尾的字符
    func substringFrom(_ index: Int) -> String {
        guard index < self.count else {
            assertionFailure("index beyound the length of the string")
            return ""
        }
        
        guard index >= 0 else {
            assertionFailure("index can't be lower than 0")
            return ""
        }
        
        let theIndex = self.index(self.endIndex, offsetBy: index - self.count)
        return String(self[theIndex..<endIndex])
    }
    
    /// 某个闭区间内的字符
    ///
    /// - Parameter range: 闭区间，例如：1...6
    /// - Returns: 子字符串
    func substringInRange(_ range: CountableClosedRange<Int>) -> String {
        
        guard range.lowerBound >= 0 else {
            assertionFailure("lowerBound of the Range can't be lower than 0")
            return ""
        }
        
        guard range.upperBound < self.count else {
            assertionFailure("upperBound of the Range beyound the length of the string")
            return ""
        }
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound + 1)
        
        return String(self[start..<end])
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

public extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}


@objc public extension NSString{
    var md5: String {
        return (self as String).md5
    }
    
    var trimmed: String {
        return (self as String).trimmed
    }
    
    func trimmedBy(_ string: String) -> String {
        return (self as String).trimmedBy(string)
    }
    
    /// 获取子字符串
    func substring(loc: Int, len: Int) -> String {
        return self.substring(with: NSRange(location: loc, length: len))
    }
    ///过滤字符集
    func replacingOccurrences(of String: String, withSet: String) -> String {
        let items: [String] = self.components(separatedBy: CharacterSet(charactersIn: withSet))
        return items.joined(separator: "")
    }
    
    ///获取两个字符串中间的部分(含这两部分)
    func substring(_ prefix: String, subfix: String, isContain: Bool = false) -> String {
        let beginLocation = self.range(of: prefix).location
        let endLocation = self.range(of: subfix, options: .backwards).location
        if beginLocation == NSNotFound || endLocation == NSNotFound {
            return self as String
        }
        
        let beginIdx = isContain == true ? beginLocation : beginLocation + 1
        let endIdx = isContain == true ? endLocation - beginLocation + 1 : endLocation - beginLocation
        let result = self.substring(with: NSRange(location: beginIdx, length: endIdx))
        return result
    }
    
    /// 字符串本身大于string
    func isCompare(_ string: NSString) -> Bool {
        if self.isEqual(to: "") {
            return false
        }
        
        var strSelf = self
        if strSelf.contains(".") {
            strSelf = strSelf.replacingOccurrences(of: ".", with: "") as NSString
        }
        return strSelf.integerValue > string.integerValue;
    }
    
    /// 大于version
    func isNewer(version: String) -> Bool {
        return compare(version, options: .numeric) == .orderedDescending
    }
    /// 等于version
    func isSame(version: String) -> Bool {
        return compare(version, options: .numeric) == .orderedSame
    }
    /// 小于version
    func isOlder(version: String) -> Bool {
        return compare(version, options: .numeric) == .orderedAscending
    }
    
    /// 转为拼音
    func transformToPinyin() -> String {
        let chinese: String = self as String;
        let mutableStr = NSMutableString(string: chinese) as CFMutableString
        let canTransform: Bool = CFStringTransform(mutableStr, nil, kCFStringTransformToLatin, false) &&
            CFStringTransform(mutableStr, nil, kCFStringTransformStripCombiningMarks, false);
        if canTransform == true {
            return mutableStr as String
        }
        return ""
    }
    
    /// 字符串首位加*
//    func toAsterisk() -> NSAttributedString{
//        let isMust = self.contains(kAsterisk)
//        return (self as NSString).getAttringByPrefix(kAsterisk, content: self as String, isMust: isMust)
//    }
    
    /// 复制到剪切板
    func copyToPasteboard(_ showTips: Bool) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self as String, forType: .string)
        if showTips == true {
//            _ = NSAlert.show("提示", msg: "已复制'\(self)'到剪切板!", btnTitles: [kTitleKnow], window: NSApplication.windowDefault)
        }
    }
    
    /// isEnd 为真,秒追加为:59,为假 :00
    static func dateTime(_ time: NSString, isEnd: Bool) -> NSString {
        if time.length < 10 {
            return time;
        }
        let sufix = isEnd == true ? " 23:59:59" : " 00:00:00";
        var tmp: NSString = time.substring(to: 10) as NSString;
        tmp = tmp.appending(sufix) as NSString
        return tmp;
    }
    
    /// 判断是否时间戳字符串
    func isTimeStamp() -> Bool{
        if [" ", "-", ":"].contains(self) {
            return false;
        }
        
        if self.isPureInteger() == false || self.doubleValue < NSDate().timeIntervalSince1970 {
            return false;
        }
        return true
    }
    /// 整形判断
    func isPureInteger() -> Bool{
        let scan = Scanner(string: self as String);
        var val: Int = 0;
        return (scan.scanInt(&val) && scan.isAtEnd);
    }
    /// 浮点形判断
    func isPureFloat() -> Bool{
        let scan = Scanner(string: self as String);
        var val: Float = 0.0;
        return (scan.scanFloat(&val) && scan.isAtEnd);
    }
    
    /// (短时间)yyyy-MM-dd
    func toDateShort() -> String{
        assert(self.length >= 10);
        return self.substring(to: 10);
    }
    
    /// 起始时间( 00:00:00时间戳)
    func toTimestampShort() -> String{
        assert(self.length >= 10);
        
        let tmp = self.substring(to: 10) + " 00:00:00";
        let result = DateFormatter.intervalFromDateStr(tmp, fmt: kDateFormatBegin)
        return result;
    }
    
    /// 截止时间( 23:59:59时间戳)
    func toTimestampFull() -> String{
        assert(self.length >= 10);
        
        let tmp = self.substring(to: 10) + " 23:59:59";
        let result = DateFormatter.intervalFromDateStr(tmp, fmt: kDateFormatEnd)
        return result;
    }
    
//    /// 过滤特殊字符集
//    func filter(_ string: String) -> String{
//        assert(self.length > 0);
//        let chartSet = NSCharacterSet(charactersIn: string).inverted;
//        let result = self.addingPercentEncoding(withAllowedCharacters: chartSet)
//        return result!;
//    }
    
    /// 通过集合字符的字母分割字符串
    func componentsSeparatedByCharactersInString(_ aString: String) -> [String]{
        let result = (self as NSString).components(separatedBy: CharacterSet(charactersIn: aString))
        return result;
    }
    
    /// 删除首尾空白字符
    func deleteWhiteSpaceBeginEnd() -> String{
        assert(self.length > 0);
        let chartSet = NSCharacterSet.whitespacesAndNewlines;
        let result = self.trimmingCharacters(in: chartSet)
        return result;
    }
    
    /// 取代索引处字符
    func replacingCharacter(_ index: Int) -> String{
        assert(self.length > 0);
        let result = self.replacingCharacters(in: NSMakeRange(index, 1), with: self as String)
        return result;
    }
    
    func isValidEmailAddress() -> Bool {
        let emailID: String = self as String
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
}
