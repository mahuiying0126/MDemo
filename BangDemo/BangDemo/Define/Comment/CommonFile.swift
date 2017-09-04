//
//  CommonFile.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/9.
//  Copyright © 2017年 Magic. All rights reserved.
//
import UIKit
import Foundation
import Alamofire


func MYLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if MDEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("控制器:\(fileName)---第(\(lineNum))行--打印信息--- \n\n\(message) \n\n---")
        
    #endif
}




public let Screen_height = UIScreen.main.bounds.size.height
public let Screen_width = UIScreen.main.bounds.size.width

public let Ratio_height = UIScreen.main.bounds.size.height / 667.0
public let Ratio_width = UIScreen.main.bounds.size.width / 375.0

public let Spacing_width15 : CGFloat = 15
public let Spacing_heght15 : CGFloat = 15

public let Spacing10 : CGFloat = 10


public func MIMAGE(_ imageName:String)->UIImage{
    
    return UIImage.init(named: imageName)!
}

public let LibraryDirectory  = NSHomeDirectory() + "/Library"

public let LibraryFor96k = NSHomeDirectory() + "/Library" + "/96k"

public let userDefault = UserDefaults.standard

public let USERID : String = userDefault.object(forKey: "USERID") as! String

public let KEY_UUID : String = userDefault.object(forKey: "KEY_UUID") as! String



