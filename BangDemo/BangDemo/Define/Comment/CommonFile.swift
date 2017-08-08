//
//  CommonFile.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/9.
//  Copyright © 2017年 Magic. All rights reserved.
//
import UIKit
import AlamofireImage
import SnapKit
import SwiftyJSON

func MYLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("控制器:\(fileName)---第(\(lineNum))行--打印信息---\(message)")
        
    #endif
}


public let Screen_height = UIScreen.main.bounds.size.height
public let Screen_width = UIScreen.main.bounds.size.width

public let Ratio_height = UIScreen.main.bounds.size.height / 667.0
public let Ratio_width = UIScreen.main.bounds.size.width / 375.0

public let Spacing_width = 15
public let Spacing_heght = 15

public func FONT(_ int:CGFloat) ->UIFont {
    return UIFont .systemFont(ofSize: int)
}

public func MIMAGE(_ imageName:String)->UIImage{
    
    return UIImage.init(named: imageName)!
}

public func UIColorFromRGB(_ rgbValue :NSInteger) ->UIColor{
    
    return UIColor (colorLiteralRed: ((Float)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((Float)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((Float)(rgbValue & 0xFF))/255.0, alpha: 1.0)
}

public func ColorFromRGB(_ R:Float,_ G:Float,_ B:Float ,_ A:Float)->UIColor{
    
    return UIColor (colorLiteralRed: R / 255.0 , green: G/255.0, blue: B/255.0, alpha: A)
}

public let Whit = UIColor.white
public let navColor = ColorFromRGB(62.0, 131.0, 229.0,1.0)
public let lineColor = ColorFromRGB(249, 249 , 249, 1.0)

public let LibraryDirectory : String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) .last!

public let userDefault = UserDefaults.standard

public let USERID : String = userDefault .object(forKey: "USERID") as! String

public let KEY_UUID : String = userDefault.object(forKey: "KEY_UUID") as! String



