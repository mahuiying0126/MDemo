//
//  PlistFileTool.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class PlistFileTool: NSObject {

    
    /** 存数据
     *  object,   对象
     *  key, 唯一的一个标识, 用于区分所存对象
     *  path, 文件名, 例, test.plist
     */
    
    func archiverObject(object:Any,ByKey:String) {
        ///初始化存储对象信息的data
        let data = NSMutableData()
        ///创建归档工具对象
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        ///开始归档
        archiver .encode(object, forKey: ByKey)
        ///结束归档
        archiver .finishEncoding()
        ///写入本地
        let pathStr = ByKey + "(.plist)"
        let destPath = LibraryDirectory.appending(pathStr)
        data .write(toFile: destPath, atomically: true)
        
        
    }
    
}
