//
//  NSFileManager+Helper.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/22.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa


@objc public extension FileManager{
    /// 下载目录
    static var downloadsDir = FileManager.default.urls( for: .downloadsDirectory, in:.userDomainMask).first;

    ///根据文件名和路径创建文件
    @discardableResult
    static func createFile(atPath path: String, name: String, content: String, attributes: [FileAttributeKey : Any]?, isCover: Bool = true) -> Bool {
//        let filePath = atPath + "/\(name)"
        let filePath = isCover ? "\(path)/\(name)" :  "\(path)/\(name)_\(DateFormatter.stringFromDate(Date()))";
        return FileManager.default.createFile(atPath: filePath, contents: content.data(using: .utf8), attributes: attributes)
    }
 
    ///创建文件到下载目录
    static func createFile(dirUrl: URL = FileManager.downloadsDir!, content: String, name: String, type: String, isCover: Bool = true, openDir: Bool = true){
        let fileUrl = dirUrl.appendingPathComponent("\(name).\(type)")
        let data = content.data(using: .utf8)

        let exist = FileManager.default.fileExists(atPath: fileUrl.path)
        if !exist {
            let isSuccess = FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
            print("文件创建结果: \(isSuccess)")
        } else {
            let fileName = isCover ? "\(name).\(type)" : "\(name) \(DateFormatter.stringFromDate(Date())).\(type)";
            let fileUrl = dirUrl.appendingPathComponent(fileName)
            let isSuccess = FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
            print("文件创建结果: \(isSuccess)")
        }
        if openDir {
            NSWorkspace.shared.open(dirUrl)
        }
    }
//    //创建文件到下载目录
//    static func createFile(dirUrl: URL = FileManager.downloadsDir!, content: String, name: String, isCover: Bool = true, openDir: Bool = true){
//        let fileUrl = dirUrl.appendingPathComponent(name)
//        let data = content.data(using: .utf8)
//
//        let exist = FileManager.default.fileExists(atPath: fileUrl.path)
//        if !exist {
//            let isSuccess = FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
//            print("文件创建结果: \(isSuccess)")
//        } else {
//            let fileName = isCover ? "\(name)" : "\(name) \(DateFormatter.stringFromDate(Date()))";
//            let fileUrl = dirUrl.appendingPathComponent(fileName)
//            let isSuccess = FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
//            print("文件创建结果: \(isSuccess)")
//        }
//        if openDir {
//            NSWorkspace.shared.open(dirUrl)
//        }
//    }
}
