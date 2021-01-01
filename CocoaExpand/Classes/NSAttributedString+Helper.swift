//
//  NSAttributedString+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa


@objc public extension NSAttributedString{
    
    /// 富文本配置字典
    static func AttributeDict(_ type: Int) -> [NSAttributedString.Key: Any]{
        var dic: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor:  NSColor.theme,
                                                  NSAttributedString.Key.backgroundColor:  NSColor.white,]
        
        switch type {
        case 1:
            dic[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue;
            dic[NSAttributedString.Key.underlineColor] = NSColor.theme;
            
        case 2:
            dic[NSAttributedString.Key.strikethroughStyle] = NSUnderlineStyle.single.rawValue;
            dic[NSAttributedString.Key.strikethroughColor] = NSColor.red;
            dic[NSAttributedString.Key.baselineOffset] = 0;

        case 3:
            dic[NSAttributedString.Key.obliqueness] = 0.8;
            
        case 4:
            dic[NSAttributedString.Key.expansion] = 0.3;
            
        case 5:
            dic[NSAttributedString.Key.writingDirection] = 3;
            
        default:
            break
        }
        return dic;
    }
    
    /// 富文本特殊部分配置字典
     static func attrDict(_ font: CGFloat = 15, textColor: NSColor = .theme) -> [NSAttributedString.Key: Any] {
         let dic = [NSAttributedString.Key.font: NSFont.systemFont(ofSize:font),
                    NSAttributedString.Key.foregroundColor: textColor,
                    NSAttributedString.Key.backgroundColor: NSColor.clear,
                    ];
         return dic;
     }
     
     /// 富文本整体设置
     static func paraDict(_ font: CGFloat = 15,
                          textColor: NSColor = .theme,
                          alignment: NSTextAlignment = .left) -> [NSAttributedString.Key: Any] {
         let paraStyle = NSMutableParagraphStyle();
         paraStyle.lineBreakMode = .byCharWrapping;
         paraStyle.alignment = alignment;
         
         let mdic = NSMutableDictionary(dictionary: attrDict(font, textColor: textColor));
         mdic.setObject(paraStyle, forKey:kCTParagraphStyleAttributeName as! NSCopying);
         return mdic.copy() as! [NSAttributedString.Key: Any];
     }
     
     /// [源]富文本
     static func attString(_ text: String!,
                                 textTaps: [String]!,
                                 font: CGFloat = 15,
                                 tapFont: CGFloat = 15,
                                 color: NSColor = .black,
                                 tapColor: NSColor = .theme,
                                 alignment: NSTextAlignment = .left) -> NSAttributedString {
         let paraDic = paraDict(font, textColor: color, alignment: alignment)
         let attString = NSMutableAttributedString(string: text, attributes: paraDic)
         textTaps.forEach { ( textTap: String) in
             let nsRange = (text as NSString).range(of: textTap)
             let attDic = attrDict(tapFont, textColor: tapColor)
             attString.addAttributes(attDic, range: nsRange)
         }
         return attString
     }
     
     /// 特定范围子字符串差异华显示
     static func attString(_ text: String!, offsetStart: Int, offsetEnd: Int) -> NSAttributedString! {
         let nsRange = NSRange(location: offsetStart, length: (text.count - offsetStart - offsetEnd))
         let attrString = attString(text, nsRange: nsRange)
         return attrString
     }
     
     /// 字符串差异华显示
     static func attString(_ text: String!, textSub: String) -> NSAttributedString! {
         let range = text.range(of: textSub)
         let nsRange = text.nsRange(from: range!)
         let attrString = attString(text, nsRange: nsRange)
         return attrString
     }
     
     /// nsRange范围子字符串差异华显示
     static func attString(_ text: String!, nsRange: NSRange, font: CGFloat = 15, textColor: NSColor = NSColor.theme) -> NSAttributedString! {
         assert(text.count >= (nsRange.location + nsRange.length))
         
         let attrString = NSMutableAttributedString(string: text)
         
         let attDict = [NSAttributedString.Key.foregroundColor: textColor,
                        NSAttributedString.Key.font: NSFont.systemFont(ofSize: font),
         ]
         attrString.addAttributes(attDict, range: nsRange)
         return attrString
     }
    
    static func attrString(_ text: String, font: CGFloat = 14, textColor: NSColor = NSColor.black, alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = alignment;
        
        let attDic = [NSAttributedString.Key.font:  NSFont.systemFont(ofSize: font),
                      NSAttributedString.Key.foregroundColor:  textColor,
                      NSAttributedString.Key.paragraphStyle:  paraStyle,
        ]
        let attString = NSAttributedString(string: text, attributes: attDic)
        return attString;
    }
    
    ///  富文本只有同字体大小才能计算高度
    func size(_ width: CGFloat) -> CGSize {
        let options: NSString.DrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        var size = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: options, context: nil).size;
        size.width = ceil(size.width);
        size.height = ceil(size.height);
        return size;
    }
    
    /// 定义超链接文本颜色样式
    static func hyperlink(_ string: String, url: URL, font: CGFloat = 14) -> NSAttributedString {
        let attString = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attString.length)
        
        let attDic = [NSAttributedString.Key.font:  NSFont.systemFont(ofSize: font),
                      NSAttributedString.Key.foregroundColor:  NSColor.blue,
                      NSAttributedString.Key.link:  url.absoluteURL,
                      NSAttributedString.Key.underlineStyle:  NSUnderlineStyle.single.rawValue,
//                      NSAttributedString.Key.baselineOffset:  15,

            ] as [NSAttributedString.Key : Any]
        attString.beginEditing()
        attString.addAttributes(attDic, range: range)
        attString.endEditing()
        return attString;
    }
    /// 包含超链接的全部内容
    static func hyperlink(dic: [String : String], text: String, font: NSFont) -> NSMutableAttributedString {
        let attDic: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font as Any]
        let mattStr = NSMutableAttributedString(string: text, attributes: attDic)
        for e in dic {
            let url = URL(string: e.value)
            let attStr = NSAttributedString.hyperlink(e.key, url: url!, font: font.pointSize)
            let range = (mattStr.string as NSString).range(of: e.key)
            mattStr.replaceCharacters(in: range, with: attStr)
        }
        return mattStr;
    }

}


///属性链式编程实现
@objc public extension NSMutableAttributedString {
    
    func font(_ font: NSFont) -> Self {
        addAttributes([NSAttributedString.Key.font: font], range: NSMakeRange(0, self.length))
        return self
    }
    
    func color(_ color: NSColor) -> Self {
        addAttributes([NSAttributedString.Key.foregroundColor: color], range: NSMakeRange(0, self.length))
        return self
    }
    
    func bgColor(_ color: NSColor) -> Self {
        addAttributes([NSAttributedString.Key.backgroundColor: color], range: NSMakeRange(0, self.length))
        return self
    }
    
    func link(_ value: String) -> Self {
        return linkURL(URL(string: value)!)
    }
    
    func linkURL(_ value: URL) -> Self {
        addAttributes([NSAttributedString.Key.link: value], range: NSMakeRange(0, self.length))
        return self
    }
    //设置字体倾斜度，取值为float，正值右倾，负值左倾
    func oblique(_ value: CGFloat = 0.1) -> Self {
        addAttributes([NSAttributedString.Key.obliqueness: value], range: NSMakeRange(0, self.length))
        return self
    }
       
    //字符间距
    func kern(_ value: CGFloat) -> Self {
        addAttributes([.kern: value], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置字体的横向拉伸，取值为float，正值拉伸 ，负值压缩
    func expansion(_ value: CGFloat) -> Self {
        addAttributes([.expansion: value], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置下划线
    func underline(_ style: NSUnderlineStyle = .single, _ color: NSColor) -> Self {
        addAttributes([
            .underlineColor: color,
            .underlineStyle: style.rawValue
        ], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置删除线
    func strikethrough(_ style: NSUnderlineStyle = .single, _ color: NSColor) -> Self {
        addAttributes([
            .strikethroughColor: color,
            .strikethroughStyle: style.rawValue,
        ], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置删除线
    func stroke(_ color: NSColor, _ value: CGFloat = 0) -> Self {
        addAttributes([
            .strokeColor: color,
            .strokeWidth: value,
        ], range: NSMakeRange(0, self.length))
        return self
    }
    
    ///设置基准位置 (正上负下)
    func baseline(_ value: CGFloat) -> Self {
        addAttributes([.baselineOffset: value], range: NSMakeRange(0, self.length))
        return self
    }
    
    ///设置段落
    func paraStyle(_ alignment: NSTextAlignment,
                   lineSpacing: CGFloat = 0,
                   paragraphSpacingBefore: CGFloat = 0,
                   lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> Self {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineBreakMode = lineBreakMode
        style.lineSpacing = lineSpacing
        style.paragraphSpacingBefore = paragraphSpacingBefore
        addAttributes([.paragraphStyle: style], range: NSMakeRange(0, self.length))
        return self
    }
        
    ///设置段落
    func paragraphStyle(_ style: NSMutableParagraphStyle) -> Self {
        addAttributes([.paragraphStyle: style], range: NSMakeRange(0, self.length))
        return self
    }
    
    ///设置段落
    func appendInterpolation(image: NSImage, scale: CGFloat = 1.0) -> Self {
        let attachment = NSTextAttachment()
        let size = NSSize(
          width: image.size.width * scale,
          height: image.size.height * scale
        )
        attachment.image = NSImage(size: size, flipped: false, drawingHandler: { (rect: NSRect) -> Bool in
          NSGraphicsContext.current?.cgContext.translateBy(x: 0, y: size.height)
          NSGraphicsContext.current?.cgContext.scaleBy(x: 1, y: -1)
          image.draw(in: rect)
          return true
        })
        self.append(NSAttributedString(attachment: attachment))
        return self
    }
}


public extension String {
    
    /// -> NSMutableAttributedString
    var matt: NSMutableAttributedString{
        return NSMutableAttributedString(string: self)
    }
    
}


@objc public extension NSAttributedString {
    
    /// -> NSMutableAttributedString
    var matt: NSMutableAttributedString{
        return NSMutableAttributedString(attributedString: self)
    }
    
}
